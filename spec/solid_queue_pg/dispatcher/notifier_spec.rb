class DispatcherForNotifierTest < SolidQueue::Dispatcher
  attr_reader :_booted, :_notified_to_worker

  private

  def boot
    super.tap do
      @_booted = true
    end
  end

  def notify_to_worker
    super.tap do
      @_notified_to_worker = true
    end
  end
end

describe SolidQueuePg::Dispatcher::Notifier do
  before do
    SolidQueue::Job.destroy_all
    SolidQueue::ScheduledExecution.destroy_all
  end

  let :dispatcher do
    DispatcherForNotifierTest.new(polling_interval: 0.5, batch_size: 1)
  end

  it 'sends a notification when a job enqueued' do
    thread = Thread.new { dispatcher.start }
    wait_until { dispatcher._booted }

    TestJob.set(wait_until: 1.second.after).perform_later
    wait_until { SolidQueue::ScheduledExecution.count == 0 }

    dispatcher.stop
    wait_until { thread.join }

    expect(dispatcher._notified_to_worker).to eq(true)
  end
end
