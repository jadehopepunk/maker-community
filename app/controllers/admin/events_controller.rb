module Admin
  class EventsController < AdminController
    def index
      @area_roles = Role.where(name: 'program_admin').includes(:users) || []
    end

    def show; end
  end
end
