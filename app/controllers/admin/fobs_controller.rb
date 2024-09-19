module Admin
  class FobsController < AdminController
    before_action :load_fob, only: [:edit_assignment, :assign]

    def index
      @area_roles = Role.where(name: ['people_admin', 'website_dev']).includes(:users) || []
      @fobs = Fob.page(params[:page]).order(created_at: 'DESC').per(40)
    end

    def edit_assignment
    end

    def assign
      @fob.update(assign_fob_params)
      redirect_to admin_fobs_path
    end

    private

    def load_fob
      @fob = Fob.find(params[:id])
    end

    def assign_fob_params
      params.require(:fob).permit(:user_id)
    end
  end
end
