require 'delegate'
require 'singleton'
require 'date'
require 'logger'
require 'sequel-rails'
require 'chief_transformer/candidate_measure'

class ChiefTransformer
  include Singleton

  class TransformException < StandardError; end

  cattr_accessor :logger
  self.logger = Logger.new('log/chief_error.log')

  # Number of MFCM entries to process per page. Can't be too high due to
  # memory constraints.
  cattr_accessor :per_page
  self.per_page = 1000

  def invoke
    logger.info "CHIEF Transformer started"

    Chief::Mfcm.untransformed.each_page(per_page) { |items|
      candidate_measures = CandidateMeasure::Collection.new(items.map { |mfcm|
                            if mfcm.tame.present?
                              cm = mfcm.tame.tamfs.map { |tamf|
                                CandidateMeasure.new(mfcm: mfcm, tame: mfcm.tame, tamf: tamf)
                              }
                              # When TAME has no subsidiary TAMFs and no candidate measures are built
                              # from the combo. Create Measure just from TAME record.
                              cm << CandidateMeasure.new(mfcm: mfcm, tame: mfcm.tame) if cm.empty?
                              cm
                            end
                           }.flatten.compact)
      candidate_measures.persist
      # candidate_measures.clean
    }
    # clean Mfcm, Tamf and Tame tables
  end
end
