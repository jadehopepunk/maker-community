module Admin
  class PeopleController < AdminController
    def index
      @q = load_search_query
      @filters = load_filters
      @people = load_search_results(@filters, @q)

      @plans = Plan.all
      @search_params = params.permit(filters: [], q: [:display_name_cont])

      @area_roles = Role.where(name: 'people_admin').includes(:users) || []
    end

    def show
      @person = authorize [:admin, User.find(params[:id])]
    end

    def metrics
      start_date = Date.new(2021, 11, 1)

      @member_growth = Reports::MemberGrowth.new(start_date)
    end

    private

    def load_search_query
      query = policy_scope([:admin, User]).ransack(params[:q])
      query.sorts = ['display_name asc'] if query.sorts.empty?
      query
    end

    def load_search_results(filters, query)
      filters.apply(query.result).includes(:active_plans).page(params[:page]).per(20)
    end

    def load_filters
      SearchFilters.from_params(params[:filters])
    end
  end
end
