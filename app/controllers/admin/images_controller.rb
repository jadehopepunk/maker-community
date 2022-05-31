module Admin
  class ImagesController < AdminController
    def index
      @images = Image.page(params[:page]).order(created_at: 'DESC').per(40)
    end
  end
end
