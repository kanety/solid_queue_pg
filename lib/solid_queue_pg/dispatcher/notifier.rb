# frozen_string_literal: true

module SolidQueuePg
  module Dispatcher
    module Notifier
      private

      def poll
        super.tap do |size|
          if size > 0
            SolidQueue.instrument(:send_pg_notification, process: self) do
              SolidQueue::Record.connection.execute('NOTIFY solid_queue_worker')
            end
          end
        end
      end
    end
  end
end

SolidQueue::Dispatcher.prepend SolidQueuePg::Dispatcher::Notifier
