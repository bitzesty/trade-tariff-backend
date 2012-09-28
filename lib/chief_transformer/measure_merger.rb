class ChiefTransformer
  class MeasureMerger
    # Key to use for measure merging
    cattr_accessor :merge_key
    self.merge_key = [:measure_type, :goods_nomenclature_item_id,
                      :additional_code_type, :additional_code,
                      :amend_indicator]

    attr_reader :measures, :unique_measures

    def self.merge(measures)
      new(measures).blend!.merge!.unique_measures
    end

    def initialize(measures)
      @measures = measures
    end

    def key_values_for(measure)
      merge_key.inject([]){ |memo, key|
        memo << measure.send(key)
      }
    end

    def unique_measure_map
      @unique_measure_map ||= {}
    end

    def unique_measures
      @unique_measure_map.values
    end

    def blend!
      @unique_measure_map = measures.inject({}) { |memo, measure|
        memo.merge!(Hash[key_values_for(measure), measure])
        memo
      }

      self
    end

    def merge!
      measures.each do |measure|
        key_values = key_values_for(measure)
        if unique_measure_map.has_key?(key_values)
          unique_measure = unique_measure_map[key_values]
            binding.pry if unique_measure.goods_nomenclature_item_id == "0303030300"
          unless unique_measure == measure
            # unique_measure_map[key_values] = merge(unique_measure, measure)
            m = merge(unique_measure, measure)
            m.candidate_associations.map = unique_measure.candidate_associations_map.deep_merge!(measure.candidate_associations_map)
            unique_measure_map[key_values] = m
          end
        end
      end

      self
    end

    private

    def merge(full_measure, subsidiary_measure)
      full_measure.tap {|fm|
        fm.tame = subsidiary_measure.tame if subsidiary_measure.tame.present? && fm.tame.blank?
        fm.tamf = subsidiary_measure.tamf if subsidiary_measure.tamf.present? && fm.tame.blank?
        fm.rebuild
      }
    end
  end
end
