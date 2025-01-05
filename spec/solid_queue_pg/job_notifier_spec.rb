describe SolidQueuePg::JobNotifier do
  before do
    SolidQueue::Job.destroy_all
  end

  it 'sends a notification when a job enqueued' do
    data = nil
    thread = Thread.new { data = listen }

    TestJob.perform_later
    wait_until { thread.join }

    expect(data).to eq('solid_queue_worker')
  end

  it 'sends a notification when multiple jobs enqueued' do
    data = nil
    thread = Thread.new { data = listen }

    ActiveJob.perform_all_later(2.times.map { TestJob.new })
    wait_until { thread.join }

    expect(data).to eq('solid_queue_worker')
  end
end
