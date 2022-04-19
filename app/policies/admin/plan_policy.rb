module Admin
  class PlanPolicy < ApplicationPolicy
    def update?
      admin?
    end

    private

    def admin?
      user&.has_any_role?(
        :president,
        :vice_president,
        :people_admin
      )
    end
  end
end
