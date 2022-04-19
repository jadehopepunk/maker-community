module Admin
  class PlansController < AdminController
    def index
      @plans = Plan.all
    end
  end
end
