class EventsController < ApplicationController
  def index
    @tags = load_tags
    sessions_scope = EventSession.from_this_week.only_duty_managed_until(open_times_until).date_order
    @event_sessions = sessions_scope.tagged_with(@tags).page(page).per(20)
    @sectioned_sessions = section_by_date(@event_sessions)
    @tag_counts = EventSession.tag_counts(sessions_scope)
    @url_params = params.permit(:controller, :action)
  end

  def show
    @session = EventSession.find(params[:id])
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
