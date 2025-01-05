# frozen_string_literal: true

module SolidQueuePg
  module JobNotifier
    def enqueue_all(active_jobs)
      super.tap do
        notify_to_dispatcher if active_jobs.any? { |active_job| prepared_now?(active_job) }
      end
    end

    def enqueue(active_job, ...)
      super.tap do
        notify_to_dispatcher if prepared_now?(active_job)
      end
    end

    private

    def prepared_now?(active_job)
      active_job.scheduled_at.nil? || active_job.scheduled_at <= Time.zone.now
    end

    def notify_to_dispatcher
      SolidQueue.instrument(:send_pg_notification) do
        connection.execute('NOTIFY solid_queue_worker')
      end
    end
  end
end
