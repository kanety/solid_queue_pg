# frozen_string_literal: true

module SolidQueuePg
  module Dispatcher
    module Notifier
      private

      def dispatch_next_batch
        super.tap do |batches|
          notify_to_worker if batches.size > 0
        end
      end

      def notify_to_worker
        SolidQueue.instrument(:send_pg_notification, process: self) do
          SolidQueue::Record.connection.execute('NOTIFY solid_queue_worker')
        end
      end
    end
  end
end

SolidQueue::Dispatcher.prepend SolidQueuePg::Dispatcher::Notifier
