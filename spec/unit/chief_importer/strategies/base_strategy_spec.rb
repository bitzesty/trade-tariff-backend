require 'rails_helper'

require 'chief_importer'
require 'chief_importer/strategies/base_strategy'

describe ChiefImporter::Strategies::BaseStrategy do
  let(:operations)     { ['X','U','I'] }
  let(:timestamp)      { Time.now }
  let(:operation)      { operations.sample }
  let(:args)           { [timestamp, operation] }

  describe 'initialization' do
    it 'assigns attributes, first effective timestamp and operation' do
      strategy = ChiefImporter::Strategies::BaseStrategy.new(args)
      expect(strategy.operation).to_not eq operation
    end
  end

  describe "#operation=" do
    it 'assigns correct HTTP operation' do
      strategy = ChiefImporter::Strategies::BaseStrategy.new(args)
      strategy.operation = 'X'
      expect(strategy.operation).to eq :delete
      strategy.operation = 'U'
      expect(strategy.operation).to eq :update
      strategy.operation = 'I'
      expect(strategy.operation).to eq :insert
    end
  end
end
