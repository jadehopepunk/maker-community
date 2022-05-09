class EventsController < ApplicationController
  def index
    @tags = load_tags
    sessions_scope = EventSession.from_this_week.only_duty_managed_until(open_times_until).date_order
    @event_sessions = sessions_scope.tagged_with(@tags).page(page).per(30)
    @sectioned_sessions = section_by_date(group_multi_session_days(@event_sessions))
    @tag_counts = EventSession.tag_counts(sessions_scope)
    @url_params = params.permit(:controller, :action)
  end

  def show
    @session = EventSession.find(params[:id])
    @day_sessions = @session.find_all_day_sessions
    @booking = @session.active_booking_for(current_user)
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
      session_date = event_session.is_a?(Array) ? event_session.first.date : event_session.date

      if session_date >= Date.current.beginning_of_week && session_date <= Date.current.end_of_week
        result['This week'] << event_session
      elsif session_date <= (Date.current.end_of_week + 7)
        result['Next week'] << event_session
      else
        (result[month_title(event_session.date)] ||= []) << event_session
      end
    end

    result
  end

  def group_multi_session_days(event_sessions)
    previous = nil
    event_sessions.each_with_object([]) do |event_session, result|
      if previous.nil? || previous.date != event_session.date
        result << event_session
      else
        last = result.pop
        last = [last].compact unless last.is_a?(Array)
        last << event_session

        result.push last
      end
      previous = event_session
    end
  end

  def first_page?
    page == 1
  end

  def page
    params[:page] || 1
  end

  def open_times_until
    Date.current.end_of_week + 7
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
