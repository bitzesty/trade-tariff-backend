# Keeps a record of the changes after create/update/destroy
module Sequel
  module Plugins
    module Auditable

      def self.configure(model, options = {})
        # Associations
        model.one_to_many :audits, key: :auditable_id, reciprocal: :auditable, conditions: {auditable_type: model.to_s},
                                   adder: proc{|asset| asset.update(auditable_id: model.primary_key, auditable_type: model.to_s)},
                                   remover: proc{|asset| asset.update(auditable_id: nil, auditable_type: nil)},
                                   clearer: proc{assets_dataset.update(auditable_id: nil, auditable_type: nil)}
      end
    end
  end
end