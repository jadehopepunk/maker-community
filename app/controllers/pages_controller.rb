class PagesController < ApplicationController
  def home
    @event_sessions = EventSession.one_session_per_day EventSession.future.special_event.date_order.limit(20), limit: 4
  end

  def facilities; end
end
