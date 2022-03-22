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

    def status_changed(membership, old_status, new_status, notify: true)
      return unless old_status != new_status

      SlackNotifier.new.membership_status_changed(membership, old_status, new_status) if notify
    end
  end
end
