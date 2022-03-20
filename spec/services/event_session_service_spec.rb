require 'rails_helper'

describe EventSessionService do
  include DateSpecHelpers

  describe '.create' do
    let(:spoon_carving) { create(:spoon_carving) }
    let(:spoon_carving_jan_10) { EventSession.new(event: spoon_carving, start_at: jan_time(10, 18, 30)) }

    it 'creates a new event session' do
      session = EventSessionService.create(spoon_carving_jan_10)

      expect(session).to be_persisted
    end

    it 'notifies everyone in #general on slack' do
      expect(Slack::PostMessageJob).to receive(:perform_later).with(
        channel: '#general',
        text: <<~TEXT
          New event: *Spoon Carving*
          Fri, Jan 10 at 6:30pm

          See it on our <events page|https://makercommunity.org.au/events/>
        TEXT
      )

      EventSessionService.create(spoon_carving_jan_10)
    end
  end
end
