module Admin
  class ImagesController < AdminController
    def index
      @images = Image.page(params[:page]).per(20)
    end
  end
end
