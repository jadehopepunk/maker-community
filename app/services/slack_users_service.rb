class SlackUsersService
  DELAY_AFTER_TOO_MANY_REQUESTS = 11

  class InvalidSlackRequest < RuntimeError; end
  class NoSlackUser < RuntimeError; end

  def initialize(client: Slack::Web::Client.new)
    @client = client
  end

  def update_for_all_users(async: false)
    User.find_each do |user|
      if async
        Slack::UpdateUserJob.perform_later(user)
      else
        update_for_user(user)
      end
    end
  end

  def update_for_user(user)
    slack_user = user.slack_user

    if slack_user.present?
      update_slack_user(slack_user)
    else
      create_for_user(user)
    end
  end

  def update_slack_user(slack_user)
    slack_user.update(**attributes_from_slack(slack_user.user))
  rescue NoSlackUser
    nil
  end

  def create_for_user(user)
    SlackUser.create(user:, **attributes_from_slack(user))
  rescue NoSlackUser
    nil
  end

  private

  attr_reader :client

  def slack_user_lookup(email, retries = 3)
    result = client.users_lookupByEmail(email:)
    raise InvalidSlackRequest unless result['ok']

    result['user']
  rescue Slack::Web::Api::Errors::UsersNotFound => e
    raise NoSlackUser, e.message
  rescue Slack::Web::Api::Errors::TooManyRequestsError => e
    raise e if retries <= 0

    sleep DELAY_AFTER_TOO_MANY_REQUESTS
    slack_user_lookup(email, retries - 1)
  end

  def attributes_from_slack(user)
    attributes_from_data(slack_user_lookup(user.email))
  end

  def attributes_from_data(data)
    {
      slack_user_id: data['id'],
      team_id: data['team_id'],
      name: data['name'],
      display_name: data['profile']['display_name'],
      image_48: data['profile']['image_48'],
      image_512: data['profile']['image_512']
    }
  end
end
