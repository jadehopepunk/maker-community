module Slack
  class UpdateUsersJob < ApplicationJob
    queue_as :default

    def perform()
      SlackUsersService.new.update_for_all_users(async: true)
    end
  end
end
