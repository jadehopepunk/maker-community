class UserPolicy < ApplicationPolicy
  def index?
    user.present? && user.has_role?(:people_admin)
  end
end
