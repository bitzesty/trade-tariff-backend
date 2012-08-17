require 'spec_helper'

shared_examples_for 'Base Update' do
  before do
    TariffSynchronizer.logger = Logger.new('/dev/null')
  end

  let(:example_date)      { Date.new(2012,5,15) }
  let(:example_file_name) { "#{example_date}_KBT009(12136).txt" }
  let(:example_path)      { Pathname.new("tmp/data/inbox/#{example_file_name}") }

  it 'expects file path as initializer param' do
    expect { described_class.new() }.to raise_error ArgumentError
    expect { described_class.new(example_path) }.not_to raise_error ArgumentError
    expect { described_class.new("tmp/path_as_string") }.to raise_error TariffSynchronizer::BaseUpdate::InvalidArgument
  end

  it 'parses and returns file path' do
    described_class.new(example_path).file_path.should == example_path
  end

  it 'parses and returns file name' do
    described_class.new(example_path).file_name.should == example_file_name
  end

  it 'parses and returns date as Date object' do
    described_class.new(example_path).date.should be_kind_of Date
    described_class.new(example_path).date.should == example_date
  end

  it 'has available logger' do
    expect { described_class.new(example_path).logger }.to_not raise_error
  end

  describe '#move_to' do
    let(:example_path) { create_chief_file :inbox }

    before { prepare_synchronizer_folders }

    it 'moves file in provided path to provided state folder' do
      base_update = described_class.new(example_path)
      File.exists?(base_update.file_path).should be_true
      base_update.move_to(:failbox)
      File.exists?(base_update.file_path).should be_false
      File.exists?("#{TariffSynchronizer.failbox_path}/#{base_update.file_name}").should be_true
    end

    after  { purge_synchronizer_folders }
  end

  describe '.sync' do
    before { prepare_synchronizer_folders }

    context 'when last update is for today' do
      let!(:example_chief_file) { create_chief_file :inbox }
      let!(:example_taric_file) { create_taric_file :inbox }

      it 'does not perform download' do
        described_class.expects(:download).never

        described_class.sync
      end
    end

    context 'when last update is out of date' do
      let!(:example_chief_file) { create_chief_file :inbox, Date.yesterday }
      let!(:example_taric_file) { create_taric_file :inbox, Date.yesterday }

      it 'expects download to be invoed' do
        described_class.expects(:download).at_least(:once)

        described_class.sync
      end
    end

    after  { purge_synchronizer_folders }
  end

  describe '.pending_from' do
    before { prepare_synchronizer_folders }

    context 'last downloaded file is present' do
      let!(:example_chief_file) { create_chief_file :inbox, "2010-01-01" }
      let!(:example_taric_file) { create_taric_file :inbox, "2010-01-01" }

      it 'returns date of last downloaded file' do
        pending_from_date = described_class.pending_from
        pending_from_date.should be_kind_of Date
        pending_from_date.should == Date.new(2010,1,1)
      end
    end

    context 'last downloaded file is not present' do
      it 'returns initial update date' do
        pending_from_date = described_class.pending_from
        pending_from_date.should be_kind_of Date
        pending_from_date.should == TariffSynchronizer.initial_update_for(described_class.update_type)
      end
    end

    after  { purge_synchronizer_folders }
  end

  describe '.update_type' do
    it 'raises error on base class' do
      expect { TariffSynchronizer::BaseUpdate.update_type }.to raise_error
    end

    it 'does not raise error on class that overrides it' do
      expect { described_class.update_type }.to_not raise_error
    end
  end
end
