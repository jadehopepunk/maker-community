require 'rails_helper'

describe EventBookingsService do
  include DateSpecHelpers

  describe '#create' do
    let(:jade) { create(:jade) }
    let(:event) { create(:spoon_carving) }
    let(:event_session) { EventSession.create!(event:, start_at: jan(10)) }
    let(:unsaved_booking) { EventBooking.new(session: event_session, user: jade, status: 'paid') }

    it 'saves the booking' do
      EventBookingsService.create(unsaved_booking)

      expect(unsaved_booking).to be_persisted
    end

    it 'creates a BookedForEvent user event' do
      EventBookingsService.create(unsaved_booking)

      expect(
        UserEvents::BookedForEvent.where(
          user: jade,
          subject: unsaved_booking,
          occured_at: unsaved_booking.session.start_at
        ).count
      ).to eq(1)
    end

    context 'slack message' do
      it 'queues a Slack message' do
        expect(Slack::PostMessageJob).to receive(:perform_later).with(
          channel: '#team-program',
          text: "`Jade` booked for <Spoon Carving|http://example.com/admin/event_sessions/#{event_session.id}> on Fri, Jan 10"
        )

        EventBookingsService.create(unsaved_booking)
      end

      it 'includes the person count if it was more than one' do
        booking = unsaved_booking
        booking.persons = 3

        expect(Slack::PostMessageJob).to receive(:perform_later).with(
          channel: '#team-program',
          text: "`Jade` booked 3 people for <Spoon Carving|http://example.com/admin/event_sessions/#{event_session.id}> on Fri, Jan 10"
        )

        EventBookingsService.create(booking)
      end
    end
  end
end
