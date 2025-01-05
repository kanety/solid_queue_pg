def wait_until(timeout: 5)
  Timeout.timeout(timeout) do
    loop do
      break if yield
      sleep 0.2
    end
  end
rescue
  Timeout::Error
end

def listen(timeout: 5)
  SolidQueue::Record.connection_pool.with_connection do |connection|
    connection.execute('LISTEN solid_queue_worker')
    connection.raw_connection.wait_for_notify(timeout) do |event, pid, payload|
      [event, pid, payload]
    end
  ensure
    connection.execute('UNLISTEN solid_queue_worker')
  end
end
