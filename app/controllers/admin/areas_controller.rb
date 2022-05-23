module Admin
  class AreasController < AdminController
    def index
      @area_roles = Role.where(name: 'place_admin').includes(:users) || []
    end
  end
end
