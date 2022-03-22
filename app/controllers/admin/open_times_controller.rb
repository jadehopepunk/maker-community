module Admin
  class OpenTimesController < AdminController
    def index
      @area_roles = Role.where(name: 'program_admin').includes(:users) || []
    end
  end
end
