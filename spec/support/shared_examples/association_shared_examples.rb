require 'spec_helper'

shared_examples_for 'one to one to' do |associated_object|
  @source_record =  :"#{described_class.to_s.underscore}"
  let!(:primary_key)               { associated_object.to_s.classify.constantize.primary_key }
  let!(:left_primary_key)          { primary_key }
  let!(:right_primary_key)         { primary_key }
  let!(:left_association)          { Hash[left_primary_key, send(left_primary_key)] }
  let!(:right_association)         { Hash[right_primary_key, send(right_primary_key)] }
  let!(:source_record)             { :"#{described_class.to_s.underscore}" }
  let!(:"#{associated_object}1")   { create associated_object, { validity_start_date: Date.today.ago(3.years) }.merge(right_association) }
  let!(:"#{associated_object}2")   { create associated_object, { validity_start_date: Date.today.ago(5.years) }.merge(right_association) }
  let!(@source_record)             { create source_record, left_association }

  context 'direct loading' do
    it "loads correct #{associated_object.to_s.humanize} respecting given actual time" do
      TimeMachine.now do
        send(source_record).send(associated_object).pk.should == send(:"#{associated_object}1").pk
      end
    end

    it "loads correct #{associated_object.to_s.humanize} respecting given time" do
      TimeMachine.at(1.year.ago) do
        send(source_record).send(associated_object).pk.should == send(:"#{associated_object}1").pk
      end

      TimeMachine.at(3.years.ago) do
        send(source_record).reload.send(associated_object).pk.should == send(:"#{associated_object}2").pk
      end
    end
  end

  context 'eager loading' do
    it "loads correct #{associated_object.to_s.humanize} respecting given actual time" do
      TimeMachine.now do
        described_class.where(Hash[left_primary_key, send(:"#{associated_object}1").send(primary_key)])
                       .eager(associated_object)
                       .all
                       .first
                       .send(associated_object).pk.should == send(:"#{associated_object}1").pk
      end
    end

    it "loads correct #{associated_object.to_s.humanize} respecting given time" do
      TimeMachine.at(1.year.ago) do
        described_class.where(Hash[left_primary_key, send(:"#{associated_object}1").send(primary_key)])
                       .eager(associated_object)
                       .all
                       .first
                       .send(associated_object).pk.should == send(:"#{associated_object}1").pk
      end

      TimeMachine.at(3.years.ago) do
        described_class.where(Hash[left_primary_key, send(:"#{associated_object}2").send(primary_key)])
                       .eager(associated_object)
                       .all
                       .first
                       .send(associated_object).pk.should == send(:"#{associated_object}2").pk
      end
    end
  end
end
