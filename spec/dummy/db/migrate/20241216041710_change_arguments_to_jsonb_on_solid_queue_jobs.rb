class ChangeArgumentsToJsonbOnSolidQueueJobs < ActiveRecord::Migration::Current
  def up
    change_column :solid_queue_jobs, :arguments, :jsonb, null: false, default: {}, using: 'arguments::jsonb'
    add_index :solid_queue_jobs, :arguments, using: :gin
  end

  def down
    remove_index :solid_queue_jobs, :arguments, using: :gin
    change_column :solid_queue_jobs, :arguments, :text, null: true, using: 'arguments::text'
  end
end
