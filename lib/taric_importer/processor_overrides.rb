# If certain models need to be processed out in a different way
# (see RecordProcessor#default_process) this is a the place for
# these overrides, e.g.:
#
#  Language: {
#    create: ->(attributes) {
#      Language.insert(attributes)
#    }
#  }
#
# NOTE: in case of :create and :updates must return instance of model as
#       it is going to be validated. :destroy returns nil, because we do not
#       want to be validating non existent records.
# NOTE: takes one argument: for attributes it's the attributes
# hash (string based). For create, update, destroy it's the record instance.
#
# Can also mutate attributes for all record operations, e.g.:
#
#  Language: {
#    attributes: ->(attributes) {
#      attributes[:a] = 'b'
#      attributes   # do not forget to return it
#    }
#  }

class TaricImporter < TariffImporter
  PROCESSOR_OVERRIDES = {
      Measure: {
        # Avoid naming conflicts with associations.
        attributes: ->(attributes) {
          attributes['measure_type_id'] = attributes.delete('measure_type')
          attributes['additional_code_id'] = attributes.delete('additional_code')
          attributes['geographical_area_id'] = attributes.delete('geographical_area')
          attributes['additional_code_type_id'] = attributes.delete('additional_code_type')
          attributes
        }
      },
      GoodsNomenclature: {
        update: ->(record) {
          goods_nomenclature = record.klass.filter(record.attributes.slice(*record.primary_key).symbolize_keys).first
          goods_nomenclature.set(record.attributes.except(*record.primary_key).symbolize_keys)
          goods_nomenclature.save

          ::Measure.where(goods_nomenclature_sid: goods_nomenclature.goods_nomenclature_sid)
                 .national
                 .non_invalidated.each do |measure|
            unless measure.conformant?
              measure.invalidated_by = record.transaction_id
              measure.invalidated_at = Time.now
              measure.save(validate: false)
            end
          end

          goods_nomenclature
        },
        destroy: ->(record) {
          goods_nomenclature = record.klass.filter(record.attributes.slice(*record.primary_key).symbolize_keys).first
          goods_nomenclature.set(record.attributes.except(*record.primary_key).symbolize_keys)
          goods_nomenclature.destroy
          ::Measure.where(goods_nomenclature_sid: goods_nomenclature.goods_nomenclature_sid)
                 .national
                 .non_invalidated.each do |measure|
            if measure.goods_nomenclature.blank?
              measure.invalidated_by = record.transaction_id
              measure.invalidated_at = Time.now
              measure.save(validate: false)
            end
          end

          nil
        }
      }
    }
end
