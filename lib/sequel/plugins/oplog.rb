module Sequel
  module Plugins
    module Oplog
      def self.configure(model, options = {})
        model_primary_key = options.fetch(:primary_key, model.primary_key)
        primary_key = [:oid, model_primary_key].flatten
        operation_class_name = :"#{model}::Operation"

        # Define ModelClass::Operation
        # e.g. Measure::Operation for measure oplog table
        operation_class = Class.new(Sequel::Model(:"#{model.table_name}_oplog")) do
          def record_class
            self.class.to_s.chomp("::Operation").constantize
          end
        end

        operation_class.one_to_one(
          :record,
          key: model_primary_key,
          primary_key: model_primary_key,
          foreign_key: model_primary_key,
          class_name: model
        )
        operation_class.set_primary_key(primary_key)

        model.const_set(:Operation, operation_class)
        model.const_get(:Operation).unrestrict_primary_key

        # Associations
        model.one_to_one :source, key: :oid,
                                  primary_key: :oid,
                                  class_name: operation_class_name
        model.one_to_many :operations, key: primary_key,
                                       foreign_key: primary_key,
                                       primary_key: primary_key,
                                       class_name: operation_class_name

        # Delegations
        model.delegate :operation_klass, to: model
      end

      module InstanceMethods
        # Operation can be set to :update, :insert and :delete
        # But they get persistated as U, I and D.
        def operation=(op)
          self[:operation] = op.to_s.first.upcase
        end

        def operation
          case self[:operation]
          when 'C' then :create
          when 'U' then :update
          when 'D' then :destroy
          else
            :create
          end
        end

        ##
        # will be called by https://github.com/jeremyevans/sequel/blob/5afb0d0e28a89e68f1823d77d23cfa57d6b88dad/lib/sequel/model/base.rb#L1549
        # @note fixes `NotImplementedError: You should be inserting model instances`
        def _insert_select_raw(ds)
          false
        end

        def _insert_raw(ds)
          self.operation = :create

          operation_klass.insert(self.values.except(:oid))
        end

        def _destroy_delete
          self.operation = :destroy

          operation_klass.insert(self.values.except(:oid))
        end

        def _update_columns(columns)
          self.operation = :update

          operation_klass.insert(self.values.except(:oid))
        end
      end

      # Enforce operation logging by undefining operations that do not use
      # model instances (as Insert/Update/Delete operations will not be
      # created)
      module ClassMethods
        # Hide oplog columns if asked
        def columns
          super - [:oid, :operation, :operation_date]
        end

        def insert(*args)
          raise NotImplementedError.new("You should be instantiating model and saving instances.")
        end

        def operation_klass
          @_operation_klass ||= "#{self}::Operation".constantize
        end
      end

      module DatasetMethods
        def update(*attr)
          # noop
        end

        def insert
          raise NotImplementedError.new("You should be inserting model instances.")
        end

        def delete
          raise NotImplementedError.new("You should be *destroying* model instances.")
        end
      end
    end
  end
end
