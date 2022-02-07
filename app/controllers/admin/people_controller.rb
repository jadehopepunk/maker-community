module Admin
  class PeopleController < AdminController
    def index
      authorize [:admin, User], :index?

      @q = User.ransack(params[:q])
      @people = @q.result.includes(:active_plans).page(params[:page]).per(20)
      @plans = Plan.all
      @search_params = params.permit(:page, :plan)
    end

    def show
      @person = authorize [:admin, User.find(params[:id])]
    end
  end
end
