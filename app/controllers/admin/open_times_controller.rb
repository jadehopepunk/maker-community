module Admin
  class OpenTimesController < AdminController
    skip_before_action :verify_authenticity_token, only: :bulk_update

    def index
      @month = get_month
      events = Event.duty_managed.all

      @sessions = EventSession.where(event: events).in_date_range(@month.dates)

      # @sessions = VirtualEvents::VirtualCalendar.new.virtual_sessions_during(@month.dates)
      @area_roles = Role.where(name: ['program_admin', 'duty_roster_admin']).includes(:users) || []
      @duty_managers = User.with_role(:duty_manager).order(:display_name)
    end

    def bulk_update
      AvailabilityService.bulk_update(user: current_user, creator: current_user, entries:)
      render success: true
    end

    private

    def get_month
      params[:month].present? ? Month.parse(params[:month]) : Month(Date.current)
    end

    def entries
      JSON.parse(params[:entries]).transform_values(&:symbolize_keys)
    end
  end
end
