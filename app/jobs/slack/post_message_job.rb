module Slack
  class PostMessageJob < ApplicationJob
    queue_as :default

    def perform(*params)
      client = Slack::Web::Client.new
      client.chat_postMessage(*params)
    end
  end
end
