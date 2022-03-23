class SyncJob < ApplicationJob
  queue_as :default

  def perform
    Wp::Base.sync
    Plan.update_roles
  end
end
