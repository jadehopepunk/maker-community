module Admin
  class PeopleController < AdminController
    def index
      @people = User.page(params[:page]).per(20)
    end
  end
end
