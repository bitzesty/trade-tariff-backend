require 'spec_helper'
require 'sequel/extensions/db_lock'

describe Sequel::Database do
  describe '#get_lock' do
    it 'returns true if lock was successfully acquired' do
      Sequel::Model.db.get_lock('test-lock').should == true
    end

    it 'returns false if lock was not acquired' do
      Sequel::Mysql2::Dataset.any_instance.expects(:get).returns(0)

      Sequel::Model.db.get_lock('test-lock').should == false
    end
  end

  describe '#release_lock' do
    it 'returns true if lock was successfully released' do
      Sequel::Model.db.get_lock('test-lock')
      Sequel::Model.db.release_lock('test-lock').should == true
    end

    it 'returns false if lock was not released' do
      Sequel::Model.db.release_lock('test-lock').should == false
    end
  end
end
