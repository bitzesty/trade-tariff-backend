require 'chief_transformer/measure_builders/mfcm_builder'
require 'chief_transformer/measure_builders/paginated_mfcm_builder'
require 'chief_transformer/measure_builders/tame_builder'
require 'chief_transformer/measure_builders/tamf_builder'

class ChiefTransformer
  class MeasureBuilder
    cattr_accessor :builders
    self.builders = [PaginatedMfcmBuilder, MfcmBuilder, TameBuilder, TamfBuilder]

    def self.build(builder, *args)
      raise TransformException.new("Incorrect measure builder provided") unless builder.in? builders

      builder.build(*args)
    end

    def self.build_all
      builders.inject([]) {|memo, builder|
        memo << build(builder)
        memo
      }.flatten
    end
  end
end
