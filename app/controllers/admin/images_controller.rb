module Admin
  class ImagesController < AdminController
    def index
      @images = Image.page(params[:page]).per(40)
    end
  end
end
