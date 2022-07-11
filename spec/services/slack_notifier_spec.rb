require 'rails_helper'

describe SlackNotifier do
  include DateSpecHelpers

  let(:client) { double('client') }
  subject { SlackNotifier.new(client:, delayed: false) }

  describe '#new_event_booking' do
    let(:jade) { create(:jade) }
    let(:event) { create(:spoon_carving) }
    let(:event_session) { EventSession.create!(event:, start_at: jan(10)) }
    let(:unsaved_booking) { EventBooking.new(session: event_session, user: jade, status: 'paid') }

    it 'queues a Slack message' do
      expect_message(
        channel: '#team-program',
        text: "`Jade` booked for <http://example.com/admin/program/event_sessions/#{event_session.id}|Spoon Carving> on Fri, Jan 10, 2020"
      )

      subject.new_event_booking(unsaved_booking)
    end

    it 'includes the person count if it was more than one' do
      booking = unsaved_booking
      booking.persons = 3

      expect_message(
        channel: '#team-program',
        text: "`Jade` booked 3 people for <http://example.com/admin/program/event_sessions/#{event_session.id}|Spoon Carving> on Fri, Jan 10, 2020"
      )

      subject.new_event_booking(booking)
    end
  end

  describe '#new_event_listed' do
    let(:spoon_carving) { create(:spoon_carving) }
    let(:spoon_carving_jan_10) { EventSession.new(event: spoon_carving, start_at: jan_time(10, 18, 30)) }

    it 'notifies everyone in #general' do
      expect_message(
        channel: '#events',
        text: <<~TEXT
          New event: *Spoon Carving*
          Fri, Jan 10, 2020 at 6:30pm
        TEXT
      )

      subject.new_event_listed(spoon_carving_jan_10)
    end
  end

  describe '#upcoming_this_week' do
    let(:spoon_carving) { create(:spoon_carving) }
    let(:spoon_carving_jan_10) { EventSession.new(event: spoon_carving, start_at: jan_time(10, 18, 30)) }

    context 'with no event sessions' do
      it 'does nothing' do
        expect_no_messages
        subject.upcoming_this_week(sessions: [])
      end
    end

    context 'with event sessions' do
      it 'reports on one session' do
        expect_message(
          channel: '#general',
          text: <<~TEXT
            *This Week at Maker Community*

            <https://makercommunity.org.au/events/|Events>:
            • *Spoon Carving*: Fri, Jan 10, 2020 at 6:30pm
          TEXT
        )

        subject.upcoming_this_week(sessions: [spoon_carving_jan_10])
      end
    end
  end

  def expect_no_messages
    expect(client).to receive(:chat_postMessage).never
  end

  def expect_message(text:, channel:)
    expect(client).to receive(:chat_postMessage).with({ channel:, text: })
  end
end
