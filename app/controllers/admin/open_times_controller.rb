module Admin
  class OpenTimesController < AdminController
    def index
      @month = get_month
      @area_roles = Role.where(name: 'program_admin').includes(:users) || []
    end

    private

    def get_month
      params[:month].present? ? Month.parse(params[:month]) : Month(Date.current)
    end
  end
end
