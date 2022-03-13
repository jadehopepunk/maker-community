namespace :data do
  desc 'Sync all data'
  task sync: [:environment] do
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
end
