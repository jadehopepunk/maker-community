module Admin
  class UserPolicy < ApplicationPolicy
    def basic_member_stats?
      user&.has_any_role?(
        :board_member,
        :duty_manager,
        :people_admin,
        :program_admin,
        :place_admin
      )
    end

    def show?
      basic_member_stats?
    end

    def index?
      basic_member_stats?
    end

    def show_personal_information?
      record == user || user&.has_any_role?(:president, :vice_president, :secretary, :people_admin)
    end

    def edit_availability?
      record == user || user&.has_any_role?(:program_admin, :duty_roster_admin)
    end

    def admin_roster?
      user&.has_any_role?(:program_admin, :duty_roster_admin)
    end

    class Scope
      attr_reader :user, :scope

      def initialize(user, scope)
        @user = user
        @scope = scope
      end

      def resolve
        if user&.has_any_role?(:board_member, :people_admin)
          scope.all
        else
          scope.current_participants
        end
      end
    end

    private

    def admin?
      user.present? && user.has_role?(:people_admin)
    end
  end
end
