# frozen_string_literal: true

class ApplicationPolicy
  attr_reader :user, :record

  def initialize(user, record)
    @user = user
    @record = record
  end

  def index?
    false
  end

  def show?
    false
  end

  def create?
    false
  end

  def new?
    create?
  end

  def update?
    false
  end

  def edit?
    update?
  end

  def destroy?
    false
  end

  def can_admin?
    has_any_of? %w[
      board_member
      duty_manager
      people_admin
      program_admin
      place_admin
      teacher
    ]
  end

  class Scope
    def initialize(user, scope)
      @user = user
      @scope = scope
    end

    def resolve
      scope.all
    end

    private

    attr_reader :user, :scope
  end

  private

  def has_any_of?(these_role_names)
    (these_role_names & role_names).any?
  end

  def role_names
    @role_names ||= user.roles.pluck(:name)
  end
end
