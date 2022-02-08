class MembershipService
  class << self
    def create(properties)
      membership = Membership.create!(properties)

      UserEvents::StartedMembership.create!(
        user: membership.user,
        subject: membership,
        occured_at: membership.start_at
      )

      membership
    end
  end
end
