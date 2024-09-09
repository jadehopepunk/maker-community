module Api
  class FobsController < ApplicationController
    def touch
      FobService.new.touch(params[:id])
      render json: {
        fob_id: params[:id],
        user: {
          id: "3",
          name: "John Doe"
        },
        status: "in"
      }
    end
  end
end
