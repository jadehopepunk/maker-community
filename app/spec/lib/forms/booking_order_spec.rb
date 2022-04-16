require 'rails_helper'

describe Forms::BookingOrder do
  let(:prices) { [Prices::Free.new] }
  let(:event) { create(:spoon_carving, prices:) }
  let(:event_session) { create(:spoon_carving_session, event:) }

  describe '.save' do
    context 'with missing data' do
      it 'returns false' do
        booking_order = described_class.new(event_session:)
        expect(booking_order.save).to be_falsey
      end
    end

    context 'with a user' do
      let(:jade) { create(:jade) }

      context 'with a single free person' do
        it 'saves the booking' do
          booking_order = described_class.new(event_session:, user: jade)
          booking_order.attributes = {
            price_orders_attributes: {
              1 => { persons: 1, price_id: prices.first.id }
            },
            comments: 'some comments'
          }
          expect(booking_order.save).to be_truthy

          booking = event_session.bookings.last
          expect(booking).not_to be_nil
          expect(booking.user).to eq(jade)
          expect(booking.status).to eq('complete')
          expect(booking.persons).to eql(1)
          expect(booking.comments).to eq('some comments')
        end
      end
    end
  end
end
