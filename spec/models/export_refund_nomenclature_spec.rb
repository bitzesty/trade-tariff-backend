require 'spec_helper'

describe ExportRefundNomenclature do
  describe 'associations' do
    describe 'export refund nomenclature indent' do
      let!(:export_refund_nomenclature)                { create :export_refund_nomenclature }
      let!(:export_refund_nomenclature_indent1)        { create :export_refund_nomenclature_indent,
                                                                  export_refund_nomenclature_sid: export_refund_nomenclature.export_refund_nomenclature_sid,
                                                                  validity_start_date: 2.years.ago,
                                                                  validity_end_date: nil }
      let!(:export_refund_nomenclature_indent2)        { create :export_refund_nomenclature_indent,
                                                            export_refund_nomenclature_sid: export_refund_nomenclature.export_refund_nomenclature_sid,
                                                            validity_start_date: 5.years.ago,
                                                            validity_end_date: 3.years.ago }

      context 'direct loading' do
        it 'loads correct indent respecting given actual time' do
          TimeMachine.now do
            export_refund_nomenclature.export_refund_nomenclature_indent.pk.should == export_refund_nomenclature_indent1.pk
          end
        end

        it 'loads correct indent respecting given time' do
          TimeMachine.at(1.year.ago) do
            export_refund_nomenclature.export_refund_nomenclature_indent.pk.should == export_refund_nomenclature_indent1.pk
          end

          TimeMachine.at(4.years.ago) do
            export_refund_nomenclature.reload.export_refund_nomenclature_indent.pk.should == export_refund_nomenclature_indent2.pk
          end
        end
      end

      context 'eager loading' do
        it 'loads correct indent respecting given actual time' do
          TimeMachine.now do
            ExportRefundNomenclature.where(export_refund_nomenclature_sid: export_refund_nomenclature.export_refund_nomenclature_sid)
                             .eager(:export_refund_nomenclature_indent)
                             .all
                             .first
                             .export_refund_nomenclature_indent.pk.should == export_refund_nomenclature_indent1.pk
          end
        end

        it 'loads correct indent respecting given time' do
          TimeMachine.at(1.year.ago) do
            ExportRefundNomenclature.where(export_refund_nomenclature_sid: export_refund_nomenclature.export_refund_nomenclature_sid)
                          .eager(:export_refund_nomenclature_indent)
                          .all
                          .first
                          .export_refund_nomenclature_indent.pk.should == export_refund_nomenclature_indent1.pk
          end

          TimeMachine.at(4.years.ago) do
            ExportRefundNomenclature.where(export_refund_nomenclature_sid: export_refund_nomenclature.export_refund_nomenclature_sid)
                          .eager(:export_refund_nomenclature_indent)
                          .all
                          .first
                          .export_refund_nomenclature_indent.pk.should == export_refund_nomenclature_indent2.pk
          end
        end
      end
    end

    describe 'export refund nomenclature description' do
      let!(:export_refund_nomenclature)                { create :export_refund_nomenclature }
      let!(:export_refund_nomenclature_description1)   { create :export_refund_nomenclature_description,
                                                            export_refund_nomenclature_sid: export_refund_nomenclature.export_refund_nomenclature_sid,
                                                            valid_at: 2.years.ago,
                                                            valid_to: nil }
      let!(:export_refund_nomenclature_description2) { create :export_refund_nomenclature_description,
                                                            export_refund_nomenclature_sid: export_refund_nomenclature.export_refund_nomenclature_sid,
                                                            valid_at: 5.years.ago,
                                                            valid_to: 3.years.ago }

      context 'direct loading' do
        it 'loads correct description respecting given actual time' do
          TimeMachine.now do
            export_refund_nomenclature.export_refund_nomenclature_description.pk.should == export_refund_nomenclature_description1.pk
          end
        end

        it 'loads correct description respecting given time' do
          TimeMachine.at(1.year.ago) do
            export_refund_nomenclature.export_refund_nomenclature_description.pk.should == export_refund_nomenclature_description1.pk
          end

          TimeMachine.at(4.years.ago) do
            export_refund_nomenclature.reload.export_refund_nomenclature_description.pk.should == export_refund_nomenclature_description2.pk
          end
        end
      end

      context 'eager loading' do
        it 'loads correct description respecting given actual time' do
          TimeMachine.now do
            ExportRefundNomenclature.where(export_refund_nomenclature_sid: export_refund_nomenclature.export_refund_nomenclature_sid)
                          .eager(:export_refund_nomenclature_description)
                          .all
                          .first
                          .export_refund_nomenclature_description.pk.should == export_refund_nomenclature_description1.pk
          end
        end

        it 'loads correct description respecting given time' do
          TimeMachine.at(1.year.ago) do
            ExportRefundNomenclature.where(export_refund_nomenclature_sid: export_refund_nomenclature.export_refund_nomenclature_sid)
                          .eager(:export_refund_nomenclature_description)
                          .all
                          .first
                          .export_refund_nomenclature_description.pk.should == export_refund_nomenclature_description1.pk
          end

          TimeMachine.at(4.years.ago) do
            ExportRefundNomenclature.where(export_refund_nomenclature_sid: export_refund_nomenclature.export_refund_nomenclature_sid)
                          .eager(:export_refund_nomenclature_description)
                          .all
                          .first
                          .export_refund_nomenclature_description.pk.should == export_refund_nomenclature_description2.pk
          end
        end
      end
    end
  end

  describe '#additional_code' do
    let(:export_refund_nomenclature) { build :export_refund_nomenclature }

    it 'is a concatenation of additional code type and export refund code' do
      export_refund_nomenclature.additional_code.should eq "#{export_refund_nomenclature.additional_code_type}#{export_refund_nomenclature.export_refund_code}"
    end
  end
end
