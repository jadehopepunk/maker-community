module UserEvents
  class StartedMembership < UserEvent
    def membership
      subject
    end

    def plan
      membership.plan
    end
  end
end
