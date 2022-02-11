module Admin
  class UserPolicy < ApplicationPolicy
    def basic_member_stats?
      has_any_of? %w[
        board_member
        duty_manager
        people_admin
        program_admin
        place_admin
      ]
    end

    def index?
      admin?
    end

    def show?
      admin?
    end

    private

    def admin?
      user.present? && user.has_role?(:people_admin)
    end
  end
end
