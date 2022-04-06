namespace :data do
  desc 'Sync all data ascynchronously'
  task sync: [:environment] do
    Wp::Attachment.import_async
    SyncJob.perform_later
  end

  desc 'Sync all data'
  task sync_now: [:environment] do
    Wp::Attachment.sync
    Wp::Base.sync
    Plan.update_roles
  end

  desc 'Sync all data'
  task reset: [:environment] do
    Wp::Base.sync
    Plan.update_roles
    Wp::Base.clear_passwords
  end

  desc 'Sync all images'
  task sync_images: [:environment] do
    Wp::Attachment.sync
  end

  desc 'Sync all images'
  task resync_images: [:environment] do
    Event.update_all(image_id: nil)
    Image.delete_all
    ActiveStorage::Attachment.delete_all
    ActiveStorage::Blob.delete_all
    ActiveStorage::VariantRecord.delete_all
    Wp::Attachment.sync
  end
end
