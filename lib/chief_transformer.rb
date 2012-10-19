require 'delegate'
require 'singleton'
require 'date'
require 'logger'
require 'sequel-rails'
require 'chief_transformer/candidate_measure'
require 'chief_transformer/processor'
require 'chief_transformer/batch_processor'
require 'chief_transformer/measure_logger'

Dir[File.join(Rails.root, 'lib', 'chief_transformer/interactions/*.rb')].each{|f| require f }

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
  self.per_page = 2000

  def invoke(work_mode = :update)
    raise TransformException.new("Invalid work mode, options: #{work_modes}") unless work_mode.in? work_modes

    logger.info "#{Time.now} CHIEF Transformer started: #{work_mode}"

    case work_mode
    when :initial_load
      Chief::Mfcm.initial_load.each_page(per_page) do |mfcm_batch|
        BatchProcessor.new("MfcmInsert", mfcm_batch.all).process
      end

      [Chief::Mfcm, Chief::Tame, Chief::Tamf].each{|model|
        model.unprocessed.update(processed: true)
      }
    when :update
      Processor.new(Chief::Mfcm.unprocessed.all,
                    Chief::Tame.unprocessed.all).process
    end
  end
end
