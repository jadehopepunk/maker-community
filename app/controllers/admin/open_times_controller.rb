module Admin
  class OpenTimesController < AdminController
    skip_before_action :verify_authenticity_token, only: :bulk_update

    def index
      @month = get_month
      @sessions = Events::VirtualCalendar.new.sessions_during(@month.dates)
      @area_roles = Role.where(name: ['program_admin', 'duty_roster_admin']).includes(:users) || []
      @duty_managers = User.with_role(:duty_manager).order(:display_name)
    end

    def bulk_update
      render success: true
    end

    private

    def get_month
      params[:month].present? ? Month.parse(params[:month]) : Month(Date.current)
    end
  end
end
