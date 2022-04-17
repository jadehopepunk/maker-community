require 'rails_helper'

describe OrderService do
  let(:order) { Order.create!(order_items:, comments: 'Order comment', status: 'pending', user: jade) }
  let(:order_items) { [] }
  let(:jade) { create(:jade) }

  describe '.fulfill' do
    context 'when order is an event booking order' do
      let(:session) { build(:spoon_carving_session, event:) }
      let(:event) { build(:spoon_carving) }

      context 'with a single line item' do
        let(:order_items) { [OrderItem.new(product: session, quantity: 2)] }

        it 'creates an event booking' do
          results = subject.fulfill(order)

          expect(results.length).to eq(1)
          result = results.first
          expect(result).to be_a(EventBooking)
          expect(result.user).to eq(jade)
          expect(result.comments).to eq('Order comment')
          expect(result.session).to eq(session)
          expect(result.status).to eq('complete')
          expect(result.order_item).to eq(order.order_items.first)
          expect(result.persons).to eq(2)
          expect(result.role).to eq('attendee')
        end

        it 'marks order as complete'
      end

      context 'with two lines for the same session' do
        it 'sums the quantities on the same booking'
      end
    end
  end
end
