module Admin
  class PeopleController < AdminController
    def index
      authorize [:admin, User], :index?

      @q = User.ransack(params[:q])
      @q.sorts = ['display_name asc'] if @q.sorts.empty?
      @filters = SearchFilters.from_params(params[:filters])

      @people = @filters.apply(@q.result).includes(:active_plans).page(params[:page]).per(20)
      @plans = Plan.all
      @search_params = params.permit(filters: [], q: [:display_name_cont])
    end

    def show
      @person = authorize [:admin, User.find(params[:id])]
    end
  end
end
