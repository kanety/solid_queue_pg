# frozen_string_literal: true

module SolidQueuePg
  module Worker
    module Listener
      def initialize(**options)
        @listen_timeout = options.fetch(:listen_timeout, 5)
        super
      end

      private

      def run
        start_listen
        super
      end

      def start_listen
        Thread.new do
          wrap_in_app_executor do
            listen_notification do |connection|
              loop do
                break if shutting_down?
                wait_for_notification(connection)
              end
            end
          end
        end
      end

      def listen_notification
        SolidQueue::Record.connection_pool.with_connection do |connection|
          connection.execute('LISTEN solid_queue_worker')
          yield connection
        ensure
          connection.execute('UNLISTEN solid_queue_worker')
        end
      end

      def wait_for_notification(connection)
        connection.raw_connection.wait_for_notify(@listen_timeout) do |_event, _pid, _payload|
          poll_by_listen
        end
      end

      def poll_by_listen
        SolidQueue.instrument(:received_pg_notification, process: self) do
          poll
        end
      end
    end
  end
end

SolidQueue::Worker.prepend SolidQueuePg::Worker::Listener
