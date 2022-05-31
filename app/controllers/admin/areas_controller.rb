module Admin
  class AreasController < AdminController
    def index
      @area_roles = Role.where(name: 'place_admin').includes(:users) || []

      @q = Area.ransack(params[:q])
      @q.sorts = ['name desc'] if @q.sorts.empty?
      @areas = @q.result.page(params[:page]).per(20)
    end
  end
end
