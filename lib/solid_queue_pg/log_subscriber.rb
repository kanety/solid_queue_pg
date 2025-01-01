# frozen_string_literal: true

module SolidQueuePg
  class LogSubscriber < ActiveSupport::LogSubscriber
    def send_pg_notification(event)
      debug do
        formatted_event(event, action: 'Send pg notification', **process_attributes(event))
      end
    end

    def received_pg_notification(event)
      debug do
        formatted_event(event, action: 'Received pg notification', **process_attributes(event))
      end
    end

    private

    def process_attributes(event)
      if (process = event.payload[:process])
        {
          hostname: process.hostname,
          pid: process.pid,
          name: process.name
        }
      else
        {}
      end
    end

    def formatted_event(event, action:, **attributes)
      "SolidQueue-#{SolidQueue::VERSION} #{action} (#{event.duration.round(1)}ms)  #{formatted_attributes(**attributes)}"
    end

    def formatted_attributes(**attributes)
      attributes.map { |attr, value| "#{attr}: #{value.inspect}" }.join(", ")
    end
  end
end
