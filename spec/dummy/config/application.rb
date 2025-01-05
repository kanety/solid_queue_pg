require_relative 'boot'

require 'active_record/railtie'
require 'active_job/railtie'

Bundler.require(*Rails.groups)
require 'solid_queue_pg'

module Dummy
  class Application < Rails::Application
    config.load_defaults Rails::VERSION::STRING.to_f

    config.active_job.queue_adapter = :solid_queue

    config.solid_queue.silence_polling = false
    config.solid_queue.preserve_finished_jobs = false
    config.solid_queue.supervisor_pidfile = Rails.root.join('tmp/pids/jobs.pid')
  end
end
