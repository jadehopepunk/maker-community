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
      let(:start_at) { Time.utc(2020, 1, 4, 10, 0) }
      let(:entries) do
        {
          start_at.to_s => {
            type: 'Events::OpenTime',
            availability: 'busy'
          }
        }
      end

      context 'where no event exists' do
        it 'creates event' do
          subject.bulk_update(user: bilbo, creator: bilbo, entries:)

          event = Event.find_by_slug('open-for-making')
          expect(event).not_to be_nil
          expect(event.title).to eq('Open for Making')
        end
      end

      context 'where no session exists' do
        let!(:open_for_making) { create(:open_for_making) }

        it 'creates session and availability' do
          subject.bulk_update(user: bilbo, creator: bilbo, entries:)

          session = open_for_making.sessions.first
          expect(session).not_to be_nil
          expect(session.start_at).to eq(start_at)
          expect(session.end_at).to eq(start_at + 6.hours)

          availability = session.availabilities.where(user: bilbo).first
          expect(availability).not_to be_nil
        end
      end
    end
  end
end
