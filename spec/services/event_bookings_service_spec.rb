require 'rails_helper'

describe EventBookingsService do
  include DateSpecHelpers

  describe '#create' do
    let(:jade) { create(:jade) }
    let(:event) { create(:spoon_carving) }
    let(:event_session) { EventSession.create!(event:, start_at: jan(10)) }
    let(:unsaved_booking) { EventBooking.new(session: event_session, user: jade, status: 'paid') }

    it 'saves the booking' do
      subject.create(unsaved_booking)

      expect(unsaved_booking).to be_persisted
    end

    it 'creates a BookedForEvent user event' do
      subject.create(unsaved_booking)

      expect(
        UserEvents::BookedForEvent.where(
          user: jade,
          subject: unsaved_booking,
          occured_at: unsaved_booking.session.start_at
        ).count
      ).to eq(1)
    end

    context 'slack message' do
      context 'in the future' do
        let(:event_session) { EventSession.create!(event:, start_at: Date.current + 7) }

        context 'for confirmed event' do
          it 'queues a Slack message' do
            expect_any_instance_of(SlackNotifier).to receive(:new_event_booking).with(unsaved_booking)
            subject.create(unsaved_booking)
          end
        end

        context 'for unconfirmed event' do
          let(:unsaved_booking) { EventBooking.new(session: event_session, user: jade, status: 'in-cart') }

          it 'does not enqueue a slack message' do
            expect_any_instance_of(SlackNotifier).not_to receive(:new_event_booking)
            subject.create(unsaved_booking)
          end
        end
      end
    end
  end
end
