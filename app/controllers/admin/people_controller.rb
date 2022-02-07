module Admin
  class PeopleController < AdminController
    def index
      authorize [:admin, User], :index?

      @people = User.includes(:active_plans).page(params[:page]).per(20)
      @plans = Plan.all
    end

    def show
      @person = authorize [:admin, User.find(params[:id])]
    end
  end
end
