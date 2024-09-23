module Api
  class FobsController < ApplicationController
    skip_before_action :verify_authenticity_token

    def touch
      fob_session = FobService.new.touch(params[:id])
      render json: {
        fob_id: fob_session.fob_id,
        user: user_json(fob_session.fob.user),
        status: fob_session.status
      }
    end

    private

    def user_json(user)
      return nil if user.nil?
      {
        id: user.id,
        name: user.display_name
      }
    end
  end
end
