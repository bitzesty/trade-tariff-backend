require 'delegate'
require 'singleton'
require 'date'
require 'logger'
require 'sequel-rails'
require 'chief_transformer/candidate_measure'
require 'chief_transformer/measure_builders/paginated_mfcm_builder'
require 'chief_transformer/processor'
require 'chief_transformer/measure_logger'

class ChiefTransformer
  include Singleton

  class TransformException < StandardError; end

  cattr_accessor :logger
  self.logger = Logger.new('log/chief_transformer.log')

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
    raise TransformException.new("Invalid work mode, options: #{work_modes}") unless work_mode.in? work_modes

    logger.info "#{Time.now} CHIEF Transformer started: #{work_mode}"

    case work_mode
    when :initial_load
      Chief::Mfcm.each_page(per_page) do |batch|
        candidate_measures = CandidateMeasure::Collection.new(
          batch.map { |mfcm|
            mfcm.tames.map{|tame|
              if tame.tamfs.any?
                tame.tamfs.map{|tamf|
                  CandidateMeasure.new(mfcm: mfcm, tame: tame, tamf: tamf)
                }
              else
                [CandidateMeasure.new(mfcm: mfcm, tame: tame)]
              end
            }
          }.flatten.compact)
        candidate_measures.sort
        candidate_measures.uniq
        candidate_measures.persist
      end
    when :update
      processor = Processor.new(Chief::Tame.untransformed.all,
                                Chief::Mfcm.untransformed.all)
      processor.process
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
