module Prices
  class Member < EventPrice
    VALID_PLANS = ['community_concession_member', 'community_member', 'full_time_member', 'studio_member',
                   'board_member', 'volunteer'].freeze

    def error_for(user)
      return 'sign in as a member to access this' if user.nil?
      return 'please join as a member to access this' unless user&.has_one_of_plans?(VALID_PLANS)

      nil
    end
  end
end
