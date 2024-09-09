module Api
  class FobsController < ApplicationController
    skip_before_action :verify_authenticity_token

    def touch
      fob_session = FobService.new.touch(params[:id])
      render json: {
        fob_id: fob_session.fob_id,
        user: nil,
        status: fob_session.status
      }
    end
  end
end
