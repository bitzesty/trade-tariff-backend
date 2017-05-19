require "rails_helper"
require "bank_holidays"

describe BankHolidays do
  include BankHolidaysHelper

  before do
    stub_bank_holidays_get_request
  end

  describe ".last(n)" do
    it 'should return last N halidays' do
      expect(BankHolidays.last(2).length).to eq(2)
    end

    it 'should order holidays asc' do
      res = BankHolidays.last(3)
      expect(res[0]).to eq(Date.parse("2015-10-07"))
      expect(res[2]).to eq(Date.parse("2016-11-30"))
    end

    it 'should return Date type records' do
      expect(BankHolidays.last(2)[0]).to be_a(Date)
    end

    it 'should return Array of records' do
      expect(BankHolidays.last(2)).to be_a(Array)
    end

    it 'should return max date less or equal Date.today' do
      expect(BankHolidays.last(3).last).to be <= Date.today
    end
  end
end
