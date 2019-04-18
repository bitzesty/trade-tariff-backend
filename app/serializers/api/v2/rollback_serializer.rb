module Api
  module V2
    class RollbackSerializer
      include FastJsonapi::ObjectSerializer

      set_type :rollback

      set_id :id

      attributes :user_id, :reason, :date, :keep, :enqueued_at
    end
  end
end
