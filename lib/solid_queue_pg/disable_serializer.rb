# frozen_string_literal: true

module SolidQueuePg
  module DisableSerializer
    extend ActiveSupport::Concern

    class_methods do
      def serialize(attr_name, coder: nil, type: Object, yaml: {}, **options)
        return if self.name == 'SolidQueue::Job' && attr_name == :arguments && coder.present?
        super
      end
    end
  end
end
