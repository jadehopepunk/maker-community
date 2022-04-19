module Admin
  class PlansController < AdminController
    def index
      @area_roles = Role.where(name: 'people_admin').includes(:users) || []
      @plans = Plan.page(params[:page]).per(20)
    end

    def edit
      @plan = Plan.find(params[:id])
      authorize [:admin, @plan]
    end
  end
end
