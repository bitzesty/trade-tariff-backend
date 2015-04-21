require 'rails_helper'

describe TimeMachine do
  let!(:commodity1) { create :commodity, validity_start_date: Time.now.ago(1.day),
                                         validity_end_date: Time.now.in(1.day)  }
  let!(:commodity2) { create :commodity, validity_start_date: Time.now.ago(20.days),
                                         validity_end_date: Time.now.ago(10.days) }

  describe '.at' do
    it 'sets date to current date if argument is blank' do
      TimeMachine.at(nil) {
        expect(Commodity.actual.all).to     include commodity1
        expect(Commodity.actual.all).to_not include commodity2
      }
    end

    it 'sets date to current date if argument is errorenous' do
      TimeMachine.at("#&$*(#)") {
        expect(Commodity.actual.all).to     include commodity1
        expect(Commodity.actual.all).to_not include commodity2
      }
    end

    it 'parses and sets valid date from argument' do
      TimeMachine.at(Time.now.ago(15.days).to_s) {
        expect(Commodity.actual.all).to_not include commodity1
        expect(Commodity.actual.all).to     include commodity2
      }
    end
  end

  describe '.now' do
    it 'sets date to current date' do
      TimeMachine.now {
        expect(Commodity.actual.all).to     include commodity1
        expect(Commodity.actual.all).to_not include commodity2
      }
    end
  end
end
