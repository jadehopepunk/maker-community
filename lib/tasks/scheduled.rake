namespace :scheduled do
  desc 'Run every day'
  task daily: :environment do
    ScheduledNotifications.new.start_of_week if Date.current.sunday?
  end
end
