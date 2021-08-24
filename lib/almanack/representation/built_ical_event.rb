module Almanack
  module Representation
    class BuiltIcalEvent
      attr_reader :event

      FORMAT = '%Y%m%dT%H%M%S'

      def initialize(event)
        @event = event
      end

      def ical_event
        @ical_event ||= build!
      end

      def self.for(event)
        new(event).ical_event
      end

      private

      def build!
        @ical_event = Icalendar::Event.new
        set_summary
        set_start_time
        set_end_time
        set_description
        set_location
        set_uid
        ical_event
      end

      def set_uid
        ical_event.uid = event.uid
      end

      def set_summary
        ical_event.summary = event.title
      end

      def set_start_time
        ical_event.dtstart = "#{event.start_time.strftime FORMAT}Z"
      end

      def set_end_time
        ical_event.dtend = "#{event.end_time.strftime FORMAT}Z"
      end

      def set_description
        ical_event.description = event.description if event.description
      end

      def set_location
        ical_event.location = event.location if event.location
      end

      def default_event_duration
        # Three hours is the duration for events missing end dates, a
        # recommendation suggested by Meetup.com.
        3 * ONE_HOUR
      end
    end
  end
end
