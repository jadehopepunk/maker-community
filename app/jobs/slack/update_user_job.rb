module Slack
  class UpdateUserJob < ApplicationJob
    queue_as :default

    def perform(user)
      SlackUsersService.new.update_for_user(user)
    end
  end
end
