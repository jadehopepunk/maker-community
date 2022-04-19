module Admin
  class PlansController < AdminController
    def index
      @area_roles = Role.where(name: 'people_admin').includes(:users) || []
      @plans = Plan.page(params[:page]).per(20)
    end

    def edit
      load_plan
    end

    def update
      load_plan
      if @plan.update(plan_params)
        redirect_to admin_plans_path, notice: 'Plan was successfully updated.'
      else
        render :edit
      end
    end

    private

    def load_plan
      @plan = Plan.find(params[:id])
      authorize [:admin, @plan]
    end

    def plan_params
      params.require(:plan).permit(:description)
    end
  end
end
