class TestJob < ActiveJob::Base
  def perform(time = 2)
    sleep time if time
  end
end
