module Admin
  class FobSessionsController < AdminController
    def index
      @area_roles = Role.where(name: ['people_admin', 'website_dev']).includes(:users) || []
      @fob_sessions = FobSession.page(params[:page]).order(opened_at: 'DESC').per(40)
    end
  end
end
