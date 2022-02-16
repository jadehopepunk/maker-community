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
