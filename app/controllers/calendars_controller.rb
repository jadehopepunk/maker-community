class CalendarsController < ApplicationController
  def show
    @user = User.where(calendar_token: params[:id]).first
    raise ActiveRecord::RecordNotFound unless @user

    calendar = Calendars::UserCalendar.new(@user)
    renderer = Calendars::IcalRenderer.new(calendar)

    render plain: renderer.to_s, content_type: 'text/calendar'
  end
end
