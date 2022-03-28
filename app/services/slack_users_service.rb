class SlackUsersService
  class InvalidSlackRequest < RuntimeError; end

  def initialize(client: Slack::Web::Client.new)
    @client = client
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
  end

  def create_for_user(user)
    SlackUser.create(user:, **attributes_from_slack(user))
  end

  private

  attr_reader :client

  def slack_user_lookup(email)
    result = client.users_lookupByEmail(email:)
    raise InvalidSlackRequest unless result['ok']

    result['user']
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
