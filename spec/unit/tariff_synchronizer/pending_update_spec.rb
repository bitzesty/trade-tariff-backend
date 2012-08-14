require 'spec_helper'
require 'tariff_synchronizer'

describe TariffSynchronizer::PendingUpdate do
  let(:example_date) { Date.new(2012,8,6) }
  let(:example_taric_path) { create_taric_file :inbox, example_date }
  let(:example_chief_path) { create_chief_file :inbox, "2012-05-15" }

  subject { TariffSynchronizer::PendingUpdate.new(example_taric_path) }

  before { prepare_synchronizer_folders }

  describe 'initialization' do
    it 'sets file path' do
      subject.file_path.should == example_taric_path
    end

    it 'parses date from file path' do
      subject.date.should be_kind_of Date
      subject.date.should == example_date
    end

    it 'chooses and initializes update processor from file path' do
      TariffSynchronizer::PendingUpdate.new(example_taric_path).update_processor.should be_kind_of TariffSynchronizer::TaricUpdate
      TariffSynchronizer::PendingUpdate.new(example_chief_path).update_processor.should be_kind_of TariffSynchronizer::ChiefUpdate
    end
  end

  describe '.all' do
    it 'returns paths to pending updates in failbox' do
      chief_file_path = create_chief_file :failbox

      pending_updates = TariffSynchronizer::PendingUpdate.all
      pending_updates.should be_kind_of Array
      pending_updates.size.should == 1
      pending_updates.map(&:file_path).should include chief_file_path
    end

    it 'returns paths to pending updates in inbox' do
      taric_file_path = create_taric_file :inbox

      pending_updates = TariffSynchronizer::PendingUpdate.all
      pending_updates.should be_kind_of Array
      pending_updates.size.should == 1
      pending_updates.map(&:file_path).should include taric_file_path
    end
  end

  describe '#to_s' do
    it 'returns pending update file path' do
      subject.to_s.should == example_taric_path
    end
  end

  after  { purge_synchronizer_folders }
end
