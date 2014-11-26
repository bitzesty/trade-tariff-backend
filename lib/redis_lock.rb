## taken from https://github.com/nateware/redis-objects/blob/master/lib/redis/lock.rb
## and modified to suit our needs, in particular to “bump” the lock in separate thread, specifically for long-running tasks

class RedisLock

  class LockTimeout < StandardError; end #:nodoc:

  attr_reader :key, :options
  def initialize(redis, key, options = {})
    @redis = redis
    @key = key
    @options = options
    @options[:timeout] ||= 5
    @options[:expiration] ||= 60
    @options[:sleep_interval] ||= 0.1
  end

  # Clear the lock.  Should only be needed if there's a server crash
  # or some other event that gets locks in a stuck state.
  def clear
    @redis.del(@key)
  end

  # Get the lock and execute the code block. Any other code that needs the lock
  # (on any server) will spin waiting for the lock up to the :timeout
  # that was specified when the lock was defined.
  def lock(&block)
    start = Time.now
    gotit = false
    expiration = nil

    while Time.now - start < @options[:timeout]
      expiration = generate_expiration
      # Use the expiration as the value of the lock.
      gotit = @redis.setnx(@key, expiration)
      break if gotit

      # Lock is being held.  Now check to see if it's expired (if we're using
      # lock expiration).
      # See "Handling Deadlocks" section on http://redis.io/commands/setnx
      old_expiration = @redis.get(@key).to_f

      if old_expiration < Time.now.to_f
        # If it's expired, use GETSET to update it.
        expiration = generate_expiration
        old_expiration = @redis.getset(@key, expiration).to_f

        # Since GETSET returns the old value of the lock, if the old expiration
        # is still in the past, we know no one else has expired the locked
        # and we now have it.
        if old_expiration < Time.now.to_f
          gotit = true
          break
        end
      end

      sleep @options[:sleep_interval]
    end

    raise LockTimeout, "Timeout on lock #{@key} exceeded #{@options[:timeout]} sec" unless gotit

    run_watchdog = true
    watchdog = nil

    begin
      watchdog = Thread.new {
        sleep @options[:sleep_interval]
        while run_watchdog
          expiration = generate_expiration 
          @redis.set(@key, expiration)
          sleep @options[:sleep_interval]
        end
      }

      yield

    ensure
      run_watchdog = false
      watchdog.join if watchdog

      if expiration > Time.now.to_f
        @redis.del(@key)
      end
    end
  end

  def generate_expiration
    (Time.now + @options[:expiration].to_f + 1).to_f
  end
end
