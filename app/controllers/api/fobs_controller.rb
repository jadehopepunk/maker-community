module Api
  class FobsController < ApplicationController
    skip_before_action :verify_authenticity_token

    def touch
      fob = FobService.new.touch(params[:id])
      render json: {
        fob_id: fob.id,
        user: {
          id: "3",
          name: "John Doe"
        },
        status: "in"
      }
    end
  end
end
