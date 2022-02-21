class EventsController < ApplicationController
  def index
    sessions_scope = EventSession.from_this_week
    @event_sessions = sessions_scope.page(params[:page]).per(20)
    @sectioned_sessions = section_by_date @event_sessions
    @tags = Tag.all
    @tag_counts = count_sessions_for_tags(sessions_scope, tags)
  end

  def show; end

  private

  def section_by_date(event_sessions)
    result = {
      'This week' => [],
      'Next week' => []
    }

    event_sessions.each do |event_session|
      if event_session.date >= Date.today.beginning_of_week && event_session.date <= Date.today.end_of_week
        result['This week'] << event_session
      elsif event_session.date <= (Date.today.end_of_week + 7)
        result['Next week'] << event_session
      else
        (result[month_title(event_session.date)] ||= []) << event_session
      end
    end

    result
  end

  def week_nearly_over?
    Date.today.end_of_week - Date.today <= 2
  end

  def month_title(date = Date.today)
    format_string = date.year == Date.today.year ? '%B' : '%B, %Y'
    date.strftime(format_string)
  end

  def count_sessions_for_tags(sessions_scope, tags)
    # scope = sessions_scope.where()
  end
end
