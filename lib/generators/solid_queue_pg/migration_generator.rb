# frozen_string_literal: true

require 'rails/generators'

module SolidQueuePg
  class MigrationGenerator < Rails::Generators::Base
    include Rails::Generators::Migration

    source_root File.join(File.dirname(__FILE__), 'templates')

    def create_migration_file
      migration_template "migration.rb", "db/migrate/change_arguments_to_jsonb_on_solid_queue_jobs.rb", migration_version: migration_version
    end

    private

    def migration_version
      "[#{ActiveRecord::VERSION::MAJOR}.#{ActiveRecord::VERSION::MINOR}]"
    end

    class << self
      def next_migration_number(dirname)
        next_migration_number = current_migration_number(dirname) + 1
        ActiveRecord::Migration.next_migration_number(next_migration_number)
      end
    end
  end
end
