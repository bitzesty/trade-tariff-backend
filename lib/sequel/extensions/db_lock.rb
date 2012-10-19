# Global, DB based locking support for Sequel
require 'zlib'

module Sequel
  module MySQL
    module DbLock
      module DatabaseMethods
        # Acquire lock with given name waiting max ttl time before giving
        # up
        def get_lock(lock_name, ttl = 0)
          self["SELECT GET_LOCK('#{lock_name}', #{ttl})"].get == 1
        end

        def release_lock(lock_name)
          self["SELECT RELEASE_LOCK('#{lock_name}')"].get == 1
        end
      end
    end
  end

  module Postgres
    module DbLock
      module DatabaseMethods
        # Postgres uses bigints for lock names, uses crc32 hash
        def get_lock(lock_name, ttl = 0)
          self["SELECT pg_try_advisory_lock(#{name_to_int(lock_name)})"].get == 't'
        end

        def release_lock(lock_name)
          self["SELECT pg_advisory_unlock(#{name_to_int(lock_name)})"].get == 't'
        end

        private

        def name_to_int(lock_name)
          Zlib.crc32 lock_name
        end
      end
    end
  end
end

case Sequel::Model.db.database_type
when :mysql
  Sequel::Database.send :include, Sequel::MySQL::DbLock::DatabaseMethods
when :postgres
  Sequel::Database.send :include, Sequel::Postgres::DbLock::DatabaseMethods
end

