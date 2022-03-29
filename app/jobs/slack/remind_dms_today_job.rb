module Slack
  class RemindDmsTodayJob < ApplicationJob
    queue_as :default

    def perform
      notifier = SlackNotifier.new

      EventSession.duty_managed.today.each do |session|
        notifier.duty_managers_today(session)
      end
    end
  end
end
