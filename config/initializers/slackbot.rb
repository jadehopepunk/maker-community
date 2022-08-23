Slack.configure do |config|
  config.token = ENV['SLACK_API_TOKEN']
end

Slack::Web::Client.configure do |config|
  config.ca_file = ENV['SSL_CERT_FILE']
end
