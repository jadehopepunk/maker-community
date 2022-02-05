module Admin
  class PeopleController < AdminController
    def index
      authorize User, :index?
      @people = User.page(params[:page]).per(20)
    end
  end
end
