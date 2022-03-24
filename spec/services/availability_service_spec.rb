require 'rails_helper'

describe AvailabilityService do
  include DateSpecHelpers

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
      let(:open_for_making) { create(:open_for_making) }
      let(:session) { open_for_making.sessions.create!(start_at:) }
      let(:entries) { { session.id => 'busy' } }

      context 'where no availability exists' do
        it 'creates availability' do
          subject.bulk_update(user: bilbo, creator: bilbo, entries:)

          availability = session.availabilities.where(user: bilbo).first
          expect(availability).not_to be_nil
          expect(availability.status).to eq('busy')
        end
      end
    end
  end
end
