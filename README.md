# SolidQueuePg

Add some postgresql-specific features to solid_queue.

* Replace `solid_queue_jobs.arguments` with jsonb column.
* Send a notification to workers when a job is enqueued using listen/notify feature.

## Dependencies

* ruby 3.1+
* rails 7.2+
* solid_queue 1.1

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'solid_queue_pg'
```

And then execute:

    $ bundle

## Usage

Generate migration files:

    $ rails generate solid_queue_pg:migration

Then run migration:

    $ rake db:migrate

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/kanety/solid_queue_pg.

## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).
