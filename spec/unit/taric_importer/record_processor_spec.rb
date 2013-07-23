require 'spec_helper'

require 'taric_importer'
require 'taric_importer/record_processor'

describe TaricImporter::RecordProcessor do
  # These specs use LanguageDescription model
  # we want them to not be dependent on real
  # LanguageDescriptionValidator so they wont
  # fail
  class PermissiveLanguageDescriptionValidator < TradeTariffBackend::Validator
  end

  before  { LanguageDescription.conformance_validator = PermissiveLanguageDescriptionValidator.new }
  after   { LanguageDescription.conformance_validator = nil }

  let(:record) {
    {"transaction.id"=>"31946",
     "record.code"=>"130",
     "subrecord.code"=>"05",
     "record.sequence.number"=>"1",
     "update.type"=>"3",
     "language.description"=>
      {"language.code.id"=>"FR",
       "language.id"=>"EN",
       "description"=>"French"}}
  }

  let(:operation_date) { Date.today }

  let(:processor) { described_class.new(record, operation_date) }

  describe 'initialization' do
    describe 'attribute extraction' do
      it 'assigns operation date' do
        processor.operation_date.should eq operation_date
      end

      it 'extracts operation' do
        processor.operation.should eq :create
      end

      it 'extracts transaction_id' do
        processor.transaction_id.should eq '31946'
      end

      it 'extracts klass' do
        processor.klass.should eq LanguageDescription
      end

      it 'extracts primary key' do
        processor.primary_key.should eq ['language_id', 'language_code_id']
      end

      describe 'attribute assignment and sanitization' do
        before { record['language.description'] = {'test.key' => 'value '} }

        it 'normalizes attribute keys' do
          processor.attributes.should have_key 'test_key'
        end

        it 'strips whitespace from attribute values' do
          processor.attributes['test_key'].should eq 'value'
        end

        it 'appends operation type' do
          # comes from update.type, see spec below
          processor.attributes['operation'].should eq :create
        end

        it 'appends operation date' do
          # comes from update.type, see spec below
          processor.attributes['operation_date'].should eq operation_date
        end
      end
    end
  end

  describe 'processor overrides' do
    describe 'for Measure' do
      let(:measure_record) {
        {"transaction.id"=>"31946",
         "record.code"=>"130",
         "subrecord.code"=>"05",
         "record.sequence.number"=>"1",
         "update.type"=>"3",
         "measure"=>
            {"measure_sid"=>"816171",
             "measure_type"=>"142",
             "geographical_area"=>"AD",
             "goods_nomenclature_item_id"=>"0100000000",
             "validity_start_date"=>"#{Date.today}",
             "validity_end_date"=>"#{Date.today}",
             "measure_generating_regulation_role"=>"1",
             "measure_generating_regulation_id"=>"D9006800",
             "justification_regulation_role"=>"4",
             "justification_regulation_id"=>"R0805145",
             "stopped_flag"=>"false",
             "geographical_area_sid"=>"140",
             "goods_nomenclature_sid"=>"27623",
             "ordernumber"=>nil,
             "additional_code_type"=>"15",
             "additional_code"=>"155",
             "additional_code_sid"=>nil,
             "reduction_indicator"=>nil,
             "export_refund_nomenclature_sid"=>nil,
             "national"=>nil,
             "tariff_measure_number"=>nil,
             "invalidated_by"=>nil,
             "invalidated_at"=>nil,
             "oid"=>"1",
             "operation"=>"C",
             "operation_date"=>nil}
            }
      }

      let!(:processor) { described_class.new(measure_record, operation_date) }

      it 'changes measure attributes' do
        processor.attributes['measure_type_id'].should eq measure_record['measure']['measure_type']
        processor.attributes['geographical_area_id'].should eq measure_record['measure']['geographical_area']
        processor.attributes['additional_code_type_id'].should eq measure_record['measure']['additional_code_type']
        processor.attributes['additional_code_id'].should eq measure_record['measure']['additional_code']
      end
    end
  end

  describe '#attributes=' do
    context 'model attribute override present' do
      before {
        stub_const("TaricImporter::PROCESSOR_OVERRIDES",
          LanguageDescription: {
            attributes: ->(attributes) {
              attributes.delete('language_code_id')
              attributes.delete('language_id')
              attributes
            }
          }
        )

        processor.attributes = {'language_code_id' => 'FR',
                                     'language_id' => 'EN',
                                     'description' => 'French'}
      }

      it 'returns attributes passed through override filter' do
        processor.attributes.should eq  ({ "description"=>"French",
                                           "language_code_id" => nil,
                                           "language_id" => nil })
      end
    end

    context 'model attribute override missing' do
      before {
        processor.attributes = {'language_code_id' => 'FR',
                                     'language_id' => 'EN',
                                     'description' => 'French'}
      }

      it 'returns normalized attributes' do
        processor.attributes.should eq  ({ "language_code_id"=>"FR",
                                           "language_id"=>"EN",
                                           "description"=>"French" })
      end
    end
  end

  describe '#operation=' do
    context 'update' do
      before { processor.operation = '1' }

      it 'should be set to update' do
        processor.operation.should eq :update
      end
    end

    context 'delete' do
      before { processor.operation = '2' }

      it 'should be set to destroy' do
        processor.operation.should eq :destroy
      end
    end

    context 'create' do
      before { processor.operation = '3' }

      it 'should be set to create' do
        processor.operation.should eq :create
      end
    end

    context 'unexpected operation type' do
      it 'should raise Import Exception' do
        expect { processor.operation = '4' }.to raise_error TaricImporter::ImportException
      end
    end
  end

  describe '#process!' do
    context 'process override present' do
      before {
        stub_const("TaricImporter::PROCESSOR_OVERRIDES",
          LanguageDescription: {
            create: ->(attributes) {
              raise TaricImporter::ImportException
            }
          }
        )
      }

      it 'invokes process override' do
        expect { processor.process! }.to raise_error TaricImporter::ImportException
      end
    end

    context 'default process' do
      before { LanguageDescription.unrestrict_primary_key }

      context 'create' do
        let(:record) {
          {"transaction.id"=>"31946",
           "record.code"=>"130",
           "subrecord.code"=>"05",
           "record.sequence.number"=>"1",
           "update.type"=>"3",
           "language.description"=>
            {"language.code.id"=>"FR",
             "language.id"=>"EN",
             "description"=>"French"}}
        }

        it 'persists record to db' do
          LanguageDescription.count.should eq 0
          processor.process!
          LanguageDescription.count.should eq 1
        end
      end

      context 'update' do
        context 'all values get updated' do
          let(:record) {
            {"transaction.id"=>"31946",
             "record.code"=>"130",
             "subrecord.code"=>"05",
             "record.sequence.number"=>"1",
             "update.type"=>"1",
             "language.description"=>
              {"language.code.id"=>"FR",
               "language.id"=>"EN",
               "description"=>"French!"}}
          }

          before {
            create :language_description, language_code_id: 'FR',
                                          language_id: 'EN',
                                          description: 'French'

            processor.process!
          }

          it 'does not create new records' do
            LanguageDescription.count.should eq 1
          end

          it 'updates the record' do
            LanguageDescription.first.description.should eq 'French!'
          end
        end

        context 'update does not include all values' do
          let(:record) {
            {"transaction.id"=>"31946",
             "record.code"=>"130",
             "subrecord.code"=>"05",
             "record.sequence.number"=>"1",
             "update.type"=>"1",
             "language.description"=>
              {"language.code.id"=>"FR",
               "language.id"=>"EN"}}
          }

          before {
            create :language_description, language_code_id: 'FR',
                                          language_id: 'EN',
                                          description: 'English'

            processor.process!
          }

          it 'sets missing update fields to nil' do
            LanguageDescription.first.description.should eq nil
          end
        end
      end

      context 'destroy' do
        let(:record) {
          {"transaction.id"=>"31946",
           "record.code"=>"130",
           "subrecord.code"=>"05",
           "record.sequence.number"=>"1",
           "update.type"=>"2",
           "language.description"=>
            {"language.code.id"=>"FR",
             "language.id"=>"EN",
             "description"=>"French"}}
        }

        let!(:language_desc) { create :language_description, language_code_id: 'FR',
                                                             language_id: 'EN',
                                                             description: 'French' }

        it 'destroys record' do
          LanguageDescription.count.should eq 1
          processor.process!
          LanguageDescription.count.should eq 0
        end
      end

      context 'with unconformant record' do
        # Override default validator, we want it to be failing for these cases
        class RestrictiveLanguageDescriptionValidator < TradeTariffBackend::Validator
          validation :CREATE, 'this will fail on create', on: [:create] do |record|
            false
          end

          validation :UPDATE, 'this will fail on update', on: [:update] do |record|
            false
          end

          validation :DESTROY, 'this will fail on destroy', on: [:destroy] do |record|
            false
          end
        end

        before  { LanguageDescription.conformance_validator = RestrictiveLanguageDescriptionValidator.new }
        after   { LanguageDescription.conformance_validator = PermissiveLanguageDescriptionValidator.new }

        context 'create' do
          let(:record) {
            {"transaction.id"=>"31946",
             "record.code"=>"130",
             "subrecord.code"=>"05",
             "record.sequence.number"=>"1",
             "update.type"=>"3",
             "language.description"=>
              {"language.code.id"=>"FR",
               "language.id"=>"EN",
               "description"=>"French"}}
          }

          it 'expects conformance_error event to be emitted' do
            check = false

            ActiveSupport::Notifications.subscribe /conformance_error/ do
              check = true
            end

            processor.process!

            expect(check).to be_true
          end
        end

        context 'update' do
          let(:record) {
            {"transaction.id"=>"31946",
             "record.code"=>"130",
             "subrecord.code"=>"05",
             "record.sequence.number"=>"1",
             "update.type"=>"1",
             "language.description"=>
              {"language.code.id"=>"FR",
               "language.id"=>"EN",
               "description"=>"French!"}}
          }

          it 'expects conformance_error event to be emitted' do
            create :language_description, language_code_id: 'FR',
                                          language_id: 'EN',
                                          description: 'English'

            check = false

            ActiveSupport::Notifications.subscribe /conformance_error/ do
              check = true
            end

            processor.process!

            expect(check).to be_true
          end
        end

        context 'destroy' do
          let(:record) {
            {"transaction.id"=>"31946",
             "record.code"=>"130",
             "subrecord.code"=>"05",
             "record.sequence.number"=>"1",
             "update.type"=>"2",
             "language.description"=>
              {"language.code.id"=>"FR",
               "language.id"=>"EN",
               "description"=>"French"}}
          }

          let!(:language_desc) { create :language_description, language_code_id: 'FR',
                                                               language_id: 'EN',
                                                               description: 'French' }

          it 'expects conformance_error event to be emitted' do
            check = false

            ActiveSupport::Notifications.subscribe /conformance_error/ do
              check = true
            end

            processor.process!

            expect(check).to be_true
          end
        end
      end
    end
  end
end
