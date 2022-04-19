class PeopleController < ApplicationController
  def me
    @user = current_user
  end
end
