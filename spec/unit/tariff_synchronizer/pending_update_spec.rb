require 'spec_helper'
require 'tariff_synchronizer'

describe TariffSynchronizer::PendingUpdate do
  let(:example_date) { Forgery(:date).date }
  let!(:example_chief_update) { create :chief_update, example_date: example_date }
  let!(:example_taric_update) { create :taric_update, example_date: example_date }

  subject { TariffSynchronizer::PendingUpdate.new(example_taric_update) }

  before {
    prepare_synchronizer_folders
    create_chief_file :pending, example_date
    create_taric_file :pending, example_date
  }

  describe 'initialization' do
    it 'sets file name' do
      subject.file_name.should == example_taric_update.filename
    end

    it 'chooses and initializes update processor from file path' do
      TariffSynchronizer::PendingUpdate.new(example_taric_update).update_processor.should be_kind_of TariffSynchronizer::TaricUpdate
      TariffSynchronizer::PendingUpdate.new(example_chief_update).update_processor.should be_kind_of TariffSynchronizer::ChiefUpdate
    end
  end

  describe '.all' do
    it 'returns instances of pending updates for application' do
      pending_updates = TariffSynchronizer::PendingUpdate.all
      pending_updates.should be_kind_of Array
      pending_updates.size.should == 2
      pending_updates.map(&:file_name).should include example_taric_update.filename
      pending_updates.map(&:file_name).should include example_chief_update.filename
    end
  end

  describe '#to_s' do
    it 'returns pending update file name' do
      subject.to_s.should == example_taric_update.filename
    end
  end

  after  { purge_synchronizer_folders }
end
