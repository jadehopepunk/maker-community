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

    context 'slack message' do
      let(:spoon_carving_future) { EventSession.new(event: spoon_carving, start_at: 7.days.from_now) }

      it 'notifies on slack if event is in the future' do
        expect_any_instance_of(SlackNotifier).to receive(:new_event_listed).with(spoon_carving_future)

        EventSessionService.create(spoon_carving_future)
      end
    end
  end
end
