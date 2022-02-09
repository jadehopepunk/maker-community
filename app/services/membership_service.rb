class MembershipService
  class << self
    def create(properties)
      membership = nil

      ActiveRecord::Base.transaction do
        membership = Membership.create!(properties)

        UserEvents::StartedMembership.create!(
          user: membership.user,
          subject: membership,
          occured_at: membership.start_at
        )
      end

      membership
    end
  end
end
