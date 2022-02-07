module Admin
  class PeopleController < AdminController
    def index
      authorize [:admin, User], :index?

      @q = User.ransack(params[:q])
      @q.sorts = ['display_name asc'] if @q.sorts.empty?

      @people = @q.result.includes(:active_plans).page(params[:page]).per(20)
      @plans = Plan.all
      @filters = SearchFilters.from_params(params[:filters])
      @search_params = params.permit(:page, :plan, q: [:s])
    end

    def show
      @person = authorize [:admin, User.find(params[:id])]
    end
  end
end
