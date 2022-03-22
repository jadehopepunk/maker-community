module UserEvents
  class MembershipStatusChanged < UserEvent
    delegate :plan, to: :membership

    def membership
      subject
    end

    def new_status
      data['new_status'] || 'unknown'
    end

    def old_status
      data['old_status'] || 'unknown'
    end
  end
end
