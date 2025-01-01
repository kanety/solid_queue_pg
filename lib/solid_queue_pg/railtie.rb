# frozen_string_literal: true

module SolidQueuePg
  class Railtie < Rails::Railtie
    config.after_initialize do
      SolidQueue::Job.singleton_class.prepend SolidQueuePg::JobNotifier
    end
  end
end

ActiveSupport.on_load(:solid_queue_record) do
  include SolidQueuePg::DisableSerializer
end
