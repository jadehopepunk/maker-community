require 'rails_helper'

describe OrderService do
  let(:order) { Order.new(order_items:, comment: 'Order comment', user: jade) }
  let(:order_items) { [] }
  let(:jade) { create(:jade) }

  describe '.fulfill' do
    context 'when order is an event booking order' do
      let(:session) { build(:spoon_carving_session, event:) }
      let(:event) { build(:spoon_carving, prices:) }
      let(:prices) { [free] }
      let(:free) { Prices::Free.new }

      context 'with a single line item' do
        let(:order_items) { [OrderItem.new(product: free)] }

        it 'creates an event booking' do
          results = subject.fulfill(order)

          expect(results.length).to eq(1)
          result = result.first
          expect(result).to be_a(EventBooking)
          expect(result.user).to eq(jade)
          expect(result.comments).to eq('Order comment')
        end
      end
    end
  end
end
