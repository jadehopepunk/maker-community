class SyncJob < ApplicationJob
  queue_as :default

  def perform
    Wp::BookingUploader.new.upload_bookings
    Wp::Base.sync
    Plan.update_roles
  end
end
