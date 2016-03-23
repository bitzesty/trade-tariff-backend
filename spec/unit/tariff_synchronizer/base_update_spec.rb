require 'rails_helper'
require 'tariff_synchronizer'

describe TariffSynchronizer::BaseUpdate do

  describe '.latest_applied_of_both_kinds' do
    it "Makes the right sql query" do
      expected_sql = %{SELECT DISTINCT ON ("update_type") "tariff_updates".* FROM "tariff_updates" WHERE ("state" = 'A') ORDER BY "update_type", "issue_date" DESC}
      result = TariffSynchronizer::BaseUpdate.latest_applied_of_both_kinds.sql
      expect(result).to eq(expected_sql)
    end

    it "returns only one record for each update_type" do
      create_list :chief_update, 2, :applied
      create_list :taric_update, 2, :applied
      result = TariffSynchronizer::BaseUpdate.latest_applied_of_both_kinds.all
      expect(result.size).to eq(2)
    end

    it "return only the most recen one of each update_type" do
      date = Date.new(2016, 2, 6)
      create :chief_update, :applied, issue_date: date
      create :chief_update, :applied, issue_date: date - 1
      result = TariffSynchronizer::BaseUpdate.latest_applied_of_both_kinds.all
      expect(result.size).to eq(1)
      expect(result.first.issue_date).to eq(date)
    end
  end
end
