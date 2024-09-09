module Admin
  class FobsController < AdminController
    def index
      @area_roles = Role.where(name: ['program_admin', 'website_dev']).includes(:users) || []
      @fobs = Fob.page(params[:page]).order(created_at: 'DESC').per(40)
    end
  end
end
