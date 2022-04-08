class PagesController < ApplicationController
  def home
    @event_sessions = EventSession.future.special_event.date_order.limit(3)
  end
end
