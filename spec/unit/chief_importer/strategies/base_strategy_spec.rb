require 'spec_helper'

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
      strategy.operation.should_not == operation
    end
  end

  describe "#operation=" do
    it 'assigns correct HTTP operation' do
      strategy = ChiefImporter::Strategies::BaseStrategy.new(args)
      strategy.operation = 'X'
      strategy.operation.should == :delete
      strategy.operation = 'U'
      strategy.operation.should == :update
      strategy.operation = 'I'
      strategy.operation.should == :insert
    end
  end
end
