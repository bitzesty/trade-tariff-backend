require 'spec_helper'

describe Rollback do
  describe 'validations' do
    context 'with correct date provided' do
      let(:rollback) { Rollback.new(date: "2014-01-06") }

      it 'is a valid entity' do
        expect(rollback).to be_valid
      end
    end

    context 'with incorrect date provided' do
      let(:rollback) { Rollback.new(date: "abc") }

      it 'is not a valid entity' do
        expect(rollback).not_to be_valid
      end
    end
  end
end
