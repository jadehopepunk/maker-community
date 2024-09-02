module Api
  class FobsController < ApplicationController
    def touch
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
