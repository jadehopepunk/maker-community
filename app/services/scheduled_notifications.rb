class ScheduledNotifications
  def initialize(date: Date.today, slack_notifier: SlackNotifier.new)
    @slack_notifier = slack_notifier
    @date = date
  end

  def start_of_week
    start_date = closest_week_start
    end_date = start_date.end_of_week
    date_range = start_date..end_date
    sessions = EventSession.in_date_range(date_range)

    slack_notifier.upcoming_this_week(sessions:)
  end

  private

  attr_reader :slack_notifier, :date

  def closest_week_start
    beginning = date.beginning_of_week
    return beginning if beginning >= date

    beginning + 7
  end
end
