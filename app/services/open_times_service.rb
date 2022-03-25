class OpenTimesService
  def create_sessions(date_range:, events: nil)
    events ||= Event.duty_managed

    events.each do |event|
      event.build_sessions_for_date_range(date_range)
      event.save!
    end
  end
end
