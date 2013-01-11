require 'spec_helper'
require 'unit/sequel/spec_helper'

# Modeled after https://github.com/jeremyevans/sequel/blob/master/spec/extensions/validation_class_methods_spec.rb

model_class = proc do |klass, &block|
  c = Class.new(klass)
  c.plugin :validation_class_methods
  c.plugin :tariff_validation_helper
  c.class_eval(&block) if block
  c
end

describe Sequel::Model do
  describe 'validates_exclusion_of' do
    before do
      @c = model_class.call Sequel::Model do
        columns :value
      end
      @m = @c.new
    end

    it "should validate exclusion_of with an array" do
      @c.validates_exclusion_of :value, :from => [1,2]
      @m.should be_valid
      @m.value = 1
      @m.should_not be_valid
      @m.value = 1.5
      @m.should be_valid
      @m.value = 2
      @m.should_not be_valid
      @m.value = 3
      @m.should be_valid
    end

    it "should validate exclusion_of with a range" do
      @c.validates_exclusion_of :value, :from => 1..4
      @m.should be_valid
      @m.value = 1
      @m.should_not be_valid
      @m.value = 1.5
      @m.should_not be_valid
      @m.value = 0
      @m.should be_valid
      @m.value = 5
      @m.should be_valid
    end

    it "should raise an error if exclusion_of doesn't receive a valid :in option" do
      lambda{@c.validates_exclusion_of :value}.should raise_error(ArgumentError)
      lambda{@c.validates_exclusion_of :value, :from => 1}.should raise_error(ArgumentError)
    end

    it "should raise an error if exclusion_of handles :allow_nil too" do
      @c.validates_exclusion_of :value, :from => 1..4, :allow_nil => true
      @m.value = nil
      @m.should be_valid
      @m.value = 0
      @m.should be_valid
    end
  end

  describe 'validates_validity_date_span_of' do
    before do
      @c = model_class.call Sequel::Model do
        columns :validity_start_date, :validity_end_date, :associated_record
      end
      @m = @c.new
    end

    context 'associated record blank' do
      it 'should validate validity date span' do
        @c.validates_validity_date_span_of :associated_record
        @m.associated_record = nil
        @m.should be_valid
      end
    end

    context 'associated record present' do
      before {
        @m.validity_start_date = Date.new(2013,2,1)
        @m.validity_end_date = Date.new(2013,3,1)
      }

      context 'associated record spans objects dates' do
        it 'should validate validity date span' do
          @c.validates_validity_date_span_of :associated_record
          @m.associated_record = stub(validity_start_date: Date.new(2013,1,1),
                                      validity_end_date: Date.new(2013,4,1))
          @m.should be_valid
        end
      end

      context 'associated record does not span objects dates' do
        it 'should validate validity date span (wrong start date)' do
          @c.validates_validity_date_span_of :associated_record
          @m.associated_record = stub(validity_start_date: Date.new(2013,3,1),
                                      validity_end_date: Date.new(2013,4,1))
          @m.should_not be_valid
        end

        it 'should validate validity date span (wrong end date)' do
          @c.validates_validity_date_span_of :associated_record
          @m.associated_record = stub(validity_start_date: Date.new(2013,1,1),
                                      validity_end_date: Date.new(2013,2,1))
          @m.should_not be_valid
        end

        it 'should validate validity date span (wrong both dates)' do
          @c.validates_validity_date_span_of :associated_record
          @m.associated_record = stub(validity_start_date: Date.new(2013,2,15),
                                      validity_end_date: Date.new(2013,2,15))
          @m.should_not be_valid
        end
      end
    end
  end

  describe 'validates_validity_dates' do
    before do
      @c = model_class.call Sequel::Model do
        columns :validity_start_date, :validity_end_date
      end
      @m = @c.new
    end

    it 'should validate validity dates' do
      @c.validates_validity_dates
      @m.validity_start_date = Date.new(2013,2,1)
      @m.validity_end_date = Date.new(2013,3,1)
      @m.should be_valid
      @m.validity_start_date = Date.new(2013,2,1)
      @m.validity_end_date = Date.new(2013,1,1)
      @m.should_not be_valid
    end
  end

  describe 'validates_input_of' do
    before do
      @c = model_class.call Sequel::Model do
        columns :something
      end
      @m = @c.new
    end

    context 'attribute present' do
      it 'validates input of' do
        @c.validates_input_of :something, requires: :something_to_be_true
        @m.stubs(:something_to_be_true).returns(true)
        @m.something = true
        @m.should be_valid
      end
    end

    context 'attribute blank' do
      it 'validates input of' do
        @c.validates_input_of :something, requires: :something_to_be_true
        @m.something = nil
        @m.should be_valid
      end
    end

    context 'requirement not fullfilled' do
      it 'validates input of' do
        @c.validates_input_of :something, requires: :something_to_be_true
        @m.stubs(:something_to_be_true).returns(false)
        @m.something = true
        @m.should_not be_valid
      end
    end
  end

  describe 'validates_associated' do
    context 'associated records present' do
      before do
        @c = model_class.call Sequel::Model do
          columns :something

          def mushrooms
            ['shroom', 'boom']
          end

          def there_are_at_least_two_mushrooms?
            mushrooms.size >= 2
          end

          def there_are_at_least_three_mushrooms?
            mushrooms.size >= 3
          end
        end
        @m = @c.new
      end

      context 'ensure option provided' do
        it 'should validate associated' do
          @c.validates_associated :mushrooms, ensure: :there_are_at_least_two_mushrooms?
          @m.should be_valid

          @c.validates_associated :mushrooms, ensure: :there_are_at_least_three_mushrooms?
          @m.should_not be_valid
        end
      end

      context 'ensure option missing' do
        context 'associated records are all valid' do
          it 'should validate associated' do
            @c.validates_associated :mushrooms
            @m.stubs(:mushrooms).returns([stub(valid?: true)])
            @m.should be_valid
          end
        end

        context 'some associated records are not valid' do
          it 'should validate associated' do
            @c.validates_associated :mushrooms
            @m.stubs(:mushrooms).returns([stub(valid?: true),
                                          stub(valid?: false)])
            @m.should_not be_valid
          end
        end
      end
    end

    context 'associated records missing' do
      before do
        @c = model_class.call Sequel::Model do
          columns :something

          def mushrooms
            nil
          end
        end
        @m = @c.new
      end

      it 'should validate associated' do
        @c.validates_associated :mushrooms
        @m.should be_valid
      end
    end
  end
end
