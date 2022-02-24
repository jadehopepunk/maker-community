class EventsController < ApplicationController
  def index
    @tags = load_tags
    sessions_scope = EventSession.from_this_week
    @event_sessions = sessions_scope.tagged_with(@tags).page(params[:page]).per(20)
    @sectioned_sessions = section_by_date @event_sessions
    @tag_counts = EventSession.tag_counts(sessions_scope)
    @url_params = params.permit(:controller, :action)
  end

  def show; end

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
