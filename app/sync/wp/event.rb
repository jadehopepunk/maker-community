module Wp
  class Event < Wp::Product
    class << self
      def sync; end

      def all_events
        find Term.events.post_ids
      end
    end
  end
end
