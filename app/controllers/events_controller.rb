class EventsController < ApplicationController
  def index
    @tags = load_tags
    sessions_scope = EventSession.from_this_week
    @event_sessions = sessions_scope.tagged_with(@tags).page(page).per(20)
    @sectioned_sessions = add_open_times section_by_date(@event_sessions)
    @tag_counts = EventSession.tag_counts(sessions_scope)
    @url_params = params.permit(:controller, :action)
  end

  def show
    @event_session = EventSession.find(params[:id])
  end

  private

  def load_tags
    [params[:tag]].reject(&:blank?).map(&:downcase)
  end

  def section_by_date(event_sessions)
    result = {
      'This week' => [],
      'Next week' => []
    }

    event_sessions.each do |event_session|
      if event_session.date >= Date.current.beginning_of_week && event_session.date <= Date.current.end_of_week
        result['This week'] << event_session
      elsif event_session.date <= (Date.current.end_of_week + 7)
        result['Next week'] << event_session
      else
        (result[month_title(event_session.date)] ||= []) << event_session
      end
    end

    result
  end

  def add_open_times(section_sessions)
    return section_sessions unless first_page?

    section_sessions['This week'] = sort_by_start_time(section_sessions['This week'] + virtual_sessions(Date.current))
    section_sessions['Next week'] =
      sort_by_start_time(section_sessions['Next week'] + virtual_sessions(Date.current.end_of_week + 1))

    section_sessions
  end

  def virtual_sessions(date)
    VirtualEvents::VirtualCalendar.new.virtual_sessions_during(date..date.end_of_week)
  end

  def first_page?
    page == 1
  end

  def page
    params[:page] || 1
  end

  def week_nearly_over?
    Date.current.end_of_week - Date.current <= 2
  end

  def month_title(date = Date.current)
    format_string = date.year == Date.current.year ? '%B' : '%B, %Y'
    date.strftime(format_string)
  end

  def sort_by_start_time(sessions)
    sessions.sort do |a, b|
      a.start_at <=> b.start_at
    end
  end
end
