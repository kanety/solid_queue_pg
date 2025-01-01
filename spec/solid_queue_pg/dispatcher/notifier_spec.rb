describe SolidQueuePg::Dispatcher::Notifier do
  before do
    SolidQueue::Job.destroy_all
  end

  let :dispatcher do
    SolidQueue::Dispatcher.new(polling_interval: 0.5, batch_size: 1)
  end

  it 'sends a notification when a job enqueued' do
    data = nil
    thread1 = Thread.new { dispatcher.start }
    thread2 = Thread.new { data = listen }

    TestJob.set(wait_until: 1.second.after).perform_later
    wait_until { SolidQueue::Job.count == 0 }
    wait_until { thread2.join }

    dispatcher.stop
    wait_until { thread1.join }

    expect(data).to eq('solid_queue_worker')
  end
end
