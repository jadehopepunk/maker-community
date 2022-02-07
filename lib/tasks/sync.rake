namespace :data do
  desc 'Sync all data'
  task sync: [:environment] do
    Wp::Base.sync
  end

  desc 'Sync all data'
  task reset: [:environment] do
    Wp::Base.sync
    Wp::Base.clear_passwords
    Wp::Base.add_roles
  end
end
