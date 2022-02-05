module Admin
  class PeopleController < AdminController
    def index
      authorize [:admin, User], :index?
      @people = User.page(params[:page]).per(20)
    end

    def show
      @person = authorize [:admin, User.find(params[:id])]
    end
  end
end
