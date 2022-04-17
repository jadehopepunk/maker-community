require 'rails_helper'

describe Forms::BookingOrder do
  let(:prices) { [Prices::Free.new] }
  let(:event) { create(:spoon_carving, prices:) }
  let(:event_session) { create(:spoon_carving_session, event:) }
  let(:jade) { create(:jade) }
  let(:unclaimed_user) { create(:unclaimed_user) }

  describe '.save' do
    context 'with missing data' do
      it 'returns false' do
        booking_order = described_class.new(event_session:)
        expect(booking_order.save).to be_falsey
      end
    end

    context 'with a user' do
      context 'with a single free person' do
        it 'saves the order' do
          booking_order = described_class.new(event_session:, user: jade)
          booking_order.attributes = {
            price_orders_attributes: {
              1 => { persons: 1, price_id: prices.first.id }
            },
            comments: 'some comments'
          }
          expect(booking_order.save).to be_truthy

          order = Order.last

          expect(order).not_to be_nil
          expect(order.user).to eq(jade)
          expect(order.status).to eq('pending')
          expect(order.comments).to eq('some comments')
          expect(order.total_price).to eq(0.0)
          expect(order.total_tax).to eq(0.0)
          expect(order.order_items.count).to eq(1)

          item = order.order_items.first
          expect(item.product).to eq(prices.first)
          expect(item.name).to eq('Free')
          expect(item.quantity).to eq(1)
          expect(item.line_subtotal).to eq(0.0)
          expect(item.line_total).to eq(0.0)
          expect(item.line_tax).to eq(0.0)
        end
      end
    end

    context 'without a user' do
      let(:price_orders_attributes) { { 1 => { persons: 1, price_id: prices.first.id } } }

      it 'is invalid without a name and email' do
        booking_order = described_class.new(event_session:)
        booking_order.attributes = {
          price_orders_attributes:
        }

        expect(booking_order).not_to be_valid
      end

      it 'is invalid with an email already taken by a real user' do
        booking_order = described_class.new(event_session:)
        booking_order.attributes = {
          price_orders_attributes:,
          name: 'Jade 2',
          email: jade.email
        }

        expect(booking_order).not_to be_valid
      end

      it 'is valid if email is taken only by an unclaimed user' do
        booking_order = described_class.new(event_session:)
        booking_order.attributes = {
          price_orders_attributes:,
          name: 'Jade 2',
          email: unclaimed_user.email
        }

        expect(booking_order).to be_valid
      end

      it 'uses existing unclaimed user if email is taken by an unclaimed user' do
        booking_order = described_class.new(event_session:)
        booking_order.attributes = {
          price_orders_attributes:,
          name: 'Jade 2',
          email: unclaimed_user.email
        }
        booking_order.save

        order = Order.last
        expect(order).not_to be_nil
        expect(order.user).to eq(unclaimed_user)
      end

      it 'creates a new unclaimed user from email if possible' do
        booking_order = described_class.new(event_session:)
        booking_order.attributes = {
          price_orders_attributes:,
          name: 'Jade 2',
          email: 'jade2@user.com'
        }
        booking_order.save

        order = Order.last
        expect(order).not_to be_nil
        expect(order.user).not_to be_nil
        expect(order.user.display_name).to eq('Jade 2')
        expect(order.user.email).to eq('jade2@user.com')
        expect(order.user.sign_up_status).to eq('unclaimed')
      end
    end
  end
end
