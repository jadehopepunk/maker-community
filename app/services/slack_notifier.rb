class SlackNotifier
  include DatetimeHelper

  attr_reader :client, :delayed

  GENERAL_CHANNEL = '#general'.freeze
  PROGRAM_CHANNEL = '#team-program'.freeze

  def initialize(client: Slack::Web::Client.new, delayed: true)
    @client = client
    @delayed = delayed
  end

  def new_event_booking(booking)
    session = booking.session
    people_count = booking.persons > 1 ? " #{booking.persons} people" : ''

    post_message(
      channel: PROGRAM_CHANNEL,
      text: "`#{booking.user.display_name}` booked#{people_count} for #{event_session_admin_link(session)} on #{format_date_text(session.start_at)}"
    )
  end

  def new_event_listed(session)
    post_message(
      channel: GENERAL_CHANNEL,
      text: <<~TEXT
        New event: *#{session.event.title}*
        #{format_datetime_text(session.start_at, seperator: ' at ')}

        See it on our #{slack_link_to 'events page', 'https://makercommunity.org.au/events/'}
      TEXT
    )
  end

  def upcoming_this_week(sessions:)
    return if sessions.empty?

    post_message(
      channel: GENERAL_CHANNEL,
      text: <<~TEXT
        *This Week at Maker Community*

        <https://makercommunity.org.au/events/|Events>:
        #{sessions.map { |session| "• *#{session.title}*: #{format_datetime_text(session.start_at, seperator: ' at ')}" }.join("\n")}
      TEXT
    )
  end

  private

  def post_message(*params)
    if delayed
      Slack::PostMessageJob.perform_later(*params) unless Rails.env.test?
    else
      client.chat_postMessage(*params)
    end
  end

  def event_session_admin_link(session)
    slack_link_to session.title, url_helpers.admin_event_session_url(session)
  end

  def slack_link_to(title, url)
    "<#{url}|#{title}>"
  end

  def url_helpers
    Rails.application.routes.url_helpers
  end
end
