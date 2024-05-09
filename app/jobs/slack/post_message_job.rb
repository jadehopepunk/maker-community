module Slack
  class PostMessageJob < ApplicationJob
    queue_as :default

    def perform(*params)
      sleep 2
      client = Slack::Web::Client.new
      client.chat_postMessage(*params)
    end
  end
end
