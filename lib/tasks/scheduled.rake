namespace :scheduled do
  desc 'Run on Sunday or Monday'
  task daily: :environment do
    ScheduledNotifications.new.start_of_week if Date.current.sunday?
  end
end
