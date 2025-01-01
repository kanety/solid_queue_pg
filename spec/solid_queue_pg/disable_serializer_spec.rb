describe SolidQueuePg::DisableSerializer do
  before do
    SolidQueue::Job.destroy_all
  end

  it 'uses jsonb instead of text serializer' do
    TestJob.perform_later
    jobs = SolidQueue::Job.where("arguments->>'job_class' = 'TestJob'")
    expect(jobs.count).to eq(1)
  end
end
