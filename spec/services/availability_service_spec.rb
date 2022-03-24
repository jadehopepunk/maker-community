require 'rails_helper'

describe AvailabilityService do
  subject { described_class }

  describe '.bulk_update' do
    let(:bilbo) { create(:bilbo) }
    let(:jade) { create(:jade) }

    context 'with no entries' do
      it 'does nothing' do
        subject.bulk_update(user: bilbo, creator: bilbo, entries: [])

        expect(Availability.count).to be(0)
      end
    end
  end
end
