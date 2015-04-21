require 'redis_lock'

describe RedisLock do

  describe '#with_lock' do
    let(:redis) { double "redis" }

    context 'lock is free' do

      it 'should take a lock and execute a block' do
        expect( redis ).to receive(:setnx) { Time.now + 60 }
        expect( redis ).to receive(:del).with('test_lock')

        lock = RedisLock.new(redis, 'test_lock')
        expect{ |b| lock.lock &b }.to yield_control
      end

    end

    context 'lock is aquired' do
      it 'should "bump" timeout value' do
        expect( redis ).to receive(:setnx) { Time.now + 60 }
        expect( redis ).to receive(:set).at_least(1)
        expect( redis ).to receive(:del).with('test_lock')

        lock = RedisLock.new(redis, 'test_lock')
        lock.lock { sleep 0.5 }
      end
    end

    context 'lock is busy' do

      it 'should fail to aquire the lock in timeout window' do
        allow( redis ).to receive(:setnx).and_return nil
        allow( redis ).to receive(:get).and_return(Time.now + 60)

        lock = RedisLock.new(redis, 'test_lock', :timeout => 0.5)
        expect{ |b| lock.lock &b }.to raise_error(RedisLock::LockTimeout)
      end

      it 'should aquire stale lock' do
        allow( redis ).to receive(:setnx).and_return(nil)
        stale_at = Time.now - 60
        allow( redis ).to receive(:get).and_return(stale_at)
        allow( redis ).to receive(:getset).and_return(stale_at)
        allow( redis ).to receive(:del).with('test_lock')

        lock = RedisLock.new(redis, 'test_lock')
        expect{ |b| lock.lock &b }.to yield_control
      end

      it 'should fail gracefully if lost in battle for stale lock' do
        allow( redis ).to receive(:setnx).at_least(1).and_return(nil)
        stale_at = Time.now - 60
        allow( redis ).to receive(:get).and_return(stale_at)
        allow( redis ).to receive(:getset).and_return(Time.now + 60) # somebody took our lock
        allow( redis ).to receive(:get).at_least(1).and_return(Time.now + 60)

        lock = RedisLock.new(redis, 'test_lock', :timeout => 0.5)
        expect{ |b| lock.lock &b }.to raise_error(RedisLock::LockTimeout)
      end

    end

  end

end
