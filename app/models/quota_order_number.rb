class QuotaOrderNumber < Sequel::Model
  plugin :time_machine

  set_primary_key  :quota_order_number_sid

  one_to_one :quota_definition, eager_loader_key: :quota_order_number_sid, dataset: -> {
    actual(QuotaDefinition).where(quota_order_number_id: quota_order_number_id)
  }, eager_loader: (proc do |eo|
    eo[:rows].each{|measure| measure.associations[:quota_order_number] = nil}

    id_map = eo[:id_map]

    QuotaDefinition.actual
                   .where(quota_order_number_sid: id_map.keys).all do |quota_definition|
      if measures = id_map[quota_definition.quota_order_number_id]
        measures.each do |measure|
          measure.associations[:quota_definition] = quota_defitinion
        end
      end
    end
  end)

  one_to_one :quota_order_number_origin, primary_key: :quota_order_number_sid,
                                         key: :quota_order_number_sid

  delegate :present?, to: :quota_order_number_origin, prefix: true, allow_nil: true
end


