require 'spec_helper'

require 'chief_importer'
require 'chief_importer/change_entry'

# Define a test strategy
class ChiefImporter < TariffImporter
  module Strategies
    class TestStrategy < BaseStrategy
    end
  end
end

describe ChiefImporter::ChangeEntry do
  let(:valid_table_name)     { 'TestStrategy' }
  let(:invalid_table_name)   { 'errr' }
  let(:valid_args)           { [valid_table_name] }
  let(:invalid_args)         { [invalid_table_name] }

  describe 'initialization' do
    before(:all) do
      # make TestStrategy a valid one
      ChiefImporter.relevant_tables.push("TestStrategy")
    end

    it 'assigns table name' do
      ce = ChiefImporter::ChangeEntry.new(valid_args)
      ce.table.should == valid_table_name
    end

    it 'assigns proper available strategy' do
      ce = ChiefImporter::ChangeEntry.new(invalid_args)
      ce.table.should == invalid_table_name
      ce.strategy.should be_blank

      ce = ChiefImporter::ChangeEntry.new(valid_args)
      ce.table.should == valid_table_name
      ce.strategy.should_not be_blank
      ce.strategy.should be_kind_of ChiefImporter::Strategies::TestStrategy
    end
  end

  describe "#relevant?" do
    it 'returns false if table is relevant' do
      ChiefImporter::ChangeEntry.new(invalid_args).relevant?.should be_false
    end

    it 'returns true if table is relevant' do
      ChiefImporter.relevant_tables += valid_args

      ChiefImporter::ChangeEntry.new(valid_args).relevant?.should be_true
    end
  end
end
