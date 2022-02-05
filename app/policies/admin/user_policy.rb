module Admin
  class UserPolicy < ApplicationPolicy
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
