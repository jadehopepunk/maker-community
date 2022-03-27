module Admin
  class EventSessionsController < AdminController
    def index
      @filters = load_filters
      @search_params = params.permit(filters: [], q: [:display_name_cont])

      @area_roles = Role.where(name: 'program_admin').includes(:users) || []
      load_event_sessions_search EventSession.special_event
    end

    def show
      @event_session = EventSession.find params[:id]
      load_bookings_search @event_session.bookings
    end

    private

    def load_event_sessions_search(base_scope)
      @q = base_scope.includes(:event).ransack(params[:q])
      @q.sorts = ['start_at desc'] if @q.sorts.empty?
      @event_sessions = @filters.apply(@q.result).page(params[:page]).per(20)
    end

    def load_bookings_search(base_scope)
      @q = base_scope.includes(:user).ransack(params[:q])
      @q.sorts = ['users_display_name asc'] if @q.sorts.empty?
      @bookings = @q.result.page(params[:page]).per(20)
    end

    def load_filters
      default_filters = params[:default] == 'false' ? [] : ['event_date|future']
      SearchFilters.from_params(params[:filters] || default_filters)
    end
  end
end
