require 'rails_helper'

describe AvailabilityService do
  include DateSpecHelpers

  subject { described_class }

  describe '.bulk_update' do
    let(:bilbo) { create(:bilbo) }
    let(:jade) { create(:jade) }

    context 'with no entries' do
      it 'does nothing' do
        subject.bulk_update(user: bilbo, creator: bilbo, entries: [])

        expect(Availability.count).to be(0)
        expect(EventSession.count).to be(0)
      end
    end

    context 'with one entry' do
      let(:start_at) { jan_time(15, 18, 30) }
      let(:entries) do
        {
          start_at.to_s => {
            type: 'Events::UnpluggedNight',
            availability: 'busy'
          }
        }
      end

      context 'where no event exists' do
        it 'creates event' do
          subject.bulk_update(user: bilbo, creator: bilbo, entries:)

          event = Event.find_by_slug('unplugged-night')
          expect(event).not_to be_nil
          expect(event.title).to eq('Unplugged Night')
        end
      end

      context 'where no session exists' do
        xit 'creates session and availability' do
          subject.bulk_update(user: bilbo, creator: bilbo, entries:)

          session = EventSession.first
          expect(session.start_at).to eq(start_at)
        end
      end
    end
  end
end
