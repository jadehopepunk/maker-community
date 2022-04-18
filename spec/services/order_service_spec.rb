require 'rails_helper'

describe OrderService do
  subject { OrderService.new }
  let(:order) { Order.create!(order_items:, status: 'completed', user: jade) }
  let(:order_items) { [] }
  let(:jade) { create(:jade) }

  describe '.fulfill' do
    context 'when order is an event booking order' do
      let(:session) { create(:spoon_carving_session, event:) }
      let(:event) { create(:spoon_carving) }
      let(:booking) { create(:event_booking, session:, user: jade, status: 'in-cart') }

      context 'with a single line item' do
        let(:order_items) { [OrderItem.new(product: booking, quantity: 1)] }

        it 'marks the booking as completed' do
          subject.fulfill_if_complete(order)

          expect(booking.reload.status).to eq('active')
        end
      end
    end
  end
end
