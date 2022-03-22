module DateSpecHelpers
  def jan(day)
    Date.new(2020, 1, day)
  end

  def jan_time(day, hour, minute)
    Time.zone.local(2020, 1, day, hour, minute)
  end
end
