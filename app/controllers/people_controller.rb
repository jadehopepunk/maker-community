class PeopleController < ApplicationController
  def me
    @person = current_user
    render json: @person
  end
end
