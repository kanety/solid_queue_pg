class SolidQueue::WorkerForListenerTest < SolidQueue::Worker
  attr_reader :_polled_first, :_polled_by_listen

  def initialize(**options)
    super
    @mode = 'fork'
  end

  private

  def poll
    super.tap do |size|
      @_polled_first ||= true
      if @_polled_first && size > 0
        @_polled_by_listen = true
      end
    end
  end
end

describe SolidQueuePg::Worker::Listener do
  before do
    SolidQueue::Job.destroy_all
  end

  let :worker do
    SolidQueue::WorkerForListenerTest.new(queue: '*', threads: 1, polling_interval: 10000, listen_timeout: 5)
  end

  it 'listens a notification' do
    thread = Thread.new { worker.start }
    wait_until { worker._polled_first }

    TestJob.perform_later
    wait_until { SolidQueue::Job.count == 0 }

    worker.stop
    wait_until { thread.join }

    expect(worker._polled_by_listen).to eq(true)
  end
end
