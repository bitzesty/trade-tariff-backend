require 'delegate'
require 'singleton'
require 'date'
require 'logger'
require 'sequel-rails'
require 'chief_transformer/candidate_measure'
require 'chief_transformer/measure_builder'

class ChiefTransformer
  include Singleton

  class TransformException < StandardError; end

  cattr_accessor :logger
  self.logger = Logger.new('log/chief_error.log')

  # Use update mode (the default) to process daily updates. Does not perform
  # pagination, processes MFCMs, TAMEs and TAMFs, merges them and persists.
  #
  # Use initial_load mode to process initial CHIEF load. It performs
  # pagination and does not process TAMEs and TAMFs separately from MFCMs.
  cattr_accessor :work_modes
  self.work_modes = [:update, :initial_load]

  # Number of MFCM entries to process per page. Can't be too high due to
  # memory constraints. Only applicable to initial_load mode.
  mattr_accessor :per_page
  self.per_page = 1000

  def invoke(work_mode = :update)
    raise TransformException.new("Invalid work mode, options: #{modes}") unless work_mode.in? work_modes

    logger.info "CHIEF Transformer started: #{work_mode}"

    case work_mode
    when :initial_load
      MeasureBuilder::PaginatedMfcmBuilder.build({per_page: per_page}) { |measure_batch|
        CandidateMeasure::Collection.new(measure_batch).tap { |candidate_measures|
          candidate_measures.merge
          candidate_measures.persist
        }
      }
    when :update
      query_arguments = { transformed: false }
      candidate_measures = MeasureBuilder.build_all(query_arguments: query_arguments)

      CandidateMeasure::Collection.new(candidate_measures).tap {|cms|
        # cms.merge
        cms.validate
        cms.persist
      }
    end

    clean
  end

  private

  def clean
    [Chief::Mfcm, Chief::Tame, Chief::Tamf].each do |chief_model|
      chief_model.where(transformed: false).update transformed: true
    end
  end
end
