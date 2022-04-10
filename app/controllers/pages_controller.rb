class PagesController < ApplicationController
  def home
    @event_sessions = EventSession.future.special_event.date_order.limit(4)
  end

  def facilities; end
end
