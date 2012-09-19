require 'spec_helper'

describe TimeMachine do
  let!(:commodity1) { create :commodity, validity_start_date: Time.now.ago(1.day),
                                         validity_end_date: Time.now.in(1.day)  }
  let!(:commodity2) { create :commodity, validity_start_date: Time.now.ago(20.days),
                                         validity_end_date: Time.now.ago(10.days) }

  describe '.at' do
    it 'sets date to current date if argument is blank' do
      TimeMachine.at(nil) {
        Commodity.actual.all.should     include commodity1
        Commodity.actual.all.should_not include commodity2
      }
    end

    it 'sets date to current date if argument is errorenous' do
      TimeMachine.at("#&$*(#)") {
        Commodity.actual.all.should     include commodity1
        Commodity.actual.all.should_not include commodity2
      }
    end

    it 'parses and sets valid date from argument' do
      TimeMachine.at(Time.now.ago(15.days).to_s) {
        Commodity.actual.all.should_not include commodity1
        Commodity.actual.all.should     include commodity2
      }
    end
  end

  describe '.now' do
    it 'sets date to current date' do
      TimeMachine.now {
        Commodity.actual.all.should     include commodity1
        Commodity.actual.all.should_not include commodity2
      }
    end
  end
end
