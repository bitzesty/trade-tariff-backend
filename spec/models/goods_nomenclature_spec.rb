require 'rails_helper'

describe GoodsNomenclature do
  describe 'associations' do
    describe 'goods nomenclature indent' do
      context 'fetching with absolute date' do
        let!(:goods_nomenclature)                { create :goods_nomenclature }
        let!(:goods_nomenclature_indent1)        { create :goods_nomenclature_indent,
                                                                    goods_nomenclature_sid: goods_nomenclature.goods_nomenclature_sid,
                                                                    validity_start_date: 2.years.ago,
                                                                    validity_end_date: nil }
        let!(:goods_nomenclature_indent2)        { create :goods_nomenclature_indent,
                                                              goods_nomenclature_sid: goods_nomenclature.goods_nomenclature_sid,
                                                              validity_start_date: 6.years.ago,
                                                              validity_end_date: 3.years.ago }
        let!(:goods_nomenclature_indent3)        { create :goods_nomenclature_indent,
                                                              goods_nomenclature_sid: goods_nomenclature.goods_nomenclature_sid,
                                                              validity_start_date: 5.years.ago,
                                                              validity_end_date: 3.years.ago }
        context 'direct loading' do
          it 'loads correct indent respecting given actual time' do
            TimeMachine.now do
              expect(
                goods_nomenclature.goods_nomenclature_indent.pk
              ).to eq goods_nomenclature_indent1.pk
            end
          end

          it 'loads correct indent respecting given time' do
            TimeMachine.at(1.year.ago) do
              expect(
                goods_nomenclature.goods_nomenclature_indent.pk
              ).to eq goods_nomenclature_indent1.pk
            end

            TimeMachine.at(4.years.ago) do
              expect(
                goods_nomenclature.reload.goods_nomenclature_indent.pk
              ).to eq goods_nomenclature_indent3.pk
            end
          end
        end

        context 'eager loading' do
          it 'loads correct indent respecting given actual time' do
            TimeMachine.now do
              expect(
                GoodsNomenclature.where(goods_nomenclature_sid: goods_nomenclature.goods_nomenclature_sid)
                            .eager(:goods_nomenclature_indents)
                            .all
                            .first
                            .goods_nomenclature_indent.pk
              ).to eq goods_nomenclature_indent1.pk
            end
          end

          it 'loads correct indent respecting given time' do
            TimeMachine.at(1.year.ago) do
              expect(
                GoodsNomenclature.where(goods_nomenclature_sid: goods_nomenclature.goods_nomenclature_sid)
                            .eager(:goods_nomenclature_indents)
                            .all
                            .first
                            .goods_nomenclature_indent.pk
              ).to eq goods_nomenclature_indent1.pk
            end

            TimeMachine.at(4.years.ago) do
              expect(
                GoodsNomenclature.where(goods_nomenclature_sid: goods_nomenclature.goods_nomenclature_sid)
                            .eager(:goods_nomenclature_indents)
                            .all
                            .first
                            .goods_nomenclature_indent.pk
              ).to eq goods_nomenclature_indent3.pk
            end
          end
        end
      end
    end

    describe 'goods nomenclature description' do
      context 'fetching with absolute date' do
        context 'at least one end date present' do
          let!(:goods_nomenclature)                { create :goods_nomenclature }
          let!(:goods_nomenclature_description1)   { create :goods_nomenclature_description,
                                                                goods_nomenclature_sid: goods_nomenclature.goods_nomenclature_sid,
                                                                validity_start_date: 2.years.ago,
                                                                validity_end_date: nil }
          let!(:goods_nomenclature_description2) { create :goods_nomenclature_description,
                                                                goods_nomenclature_sid: goods_nomenclature.goods_nomenclature_sid,
                                                                validity_start_date: 5.years.ago,
                                                                validity_end_date: 3.years.ago }

          context 'direct loading' do
            it 'loads correct description respecting given actual time' do
              TimeMachine.now do
                expect(
                  goods_nomenclature.goods_nomenclature_description.pk
                ).to eq goods_nomenclature_description1.pk
              end
            end

            it 'loads correct description respecting given time' do
              TimeMachine.at(1.year.ago) do
                expect(
                  goods_nomenclature.goods_nomenclature_description.pk
                ).to eq goods_nomenclature_description1.pk
              end

              TimeMachine.at(4.years.ago) do
                expect(
                  goods_nomenclature.reload.goods_nomenclature_description.pk
                ).to eq goods_nomenclature_description2.pk
              end
            end
          end

          context 'eager loading' do
            it 'loads correct description respecting given actual time' do
              TimeMachine.now do
                expect(
                  GoodsNomenclature.where(goods_nomenclature_sid: goods_nomenclature.goods_nomenclature_sid)
                              .eager(:goods_nomenclature_descriptions)
                              .all
                              .first
                              .goods_nomenclature_description.pk
                ).to eq goods_nomenclature_description1.pk
              end
            end

            it 'loads correct description respecting given time' do
              TimeMachine.at(1.year.ago) do
                expect(
                  GoodsNomenclature.where(goods_nomenclature_sid: goods_nomenclature.goods_nomenclature_sid)
                              .eager(:goods_nomenclature_descriptions)
                              .all
                              .first
                              .goods_nomenclature_description.pk
                ).to eq goods_nomenclature_description1.pk
              end

              TimeMachine.at(4.years.ago) do
                expect(
                  GoodsNomenclature.where(goods_nomenclature_sid: goods_nomenclature.goods_nomenclature_sid)
                              .eager(:goods_nomenclature_descriptions)
                              .all
                              .first
                              .goods_nomenclature_description.pk
                ).to eq goods_nomenclature_description2.pk
              end
            end
          end
        end

        context 'blank end dates' do
          let!(:goods_nomenclature)                { create :goods_nomenclature }
          let!(:goods_nomenclature_description1)   { create :goods_nomenclature_description,
                                                                goods_nomenclature_sid: goods_nomenclature.goods_nomenclature_sid,
                                                                validity_start_date: 3.years.ago,
                                                                validity_end_date: nil }
          let!(:goods_nomenclature_description2) { create :goods_nomenclature_description,
                                                                goods_nomenclature_sid: goods_nomenclature.goods_nomenclature_sid,
                                                                validity_start_date: 5.years.ago,
                                                                validity_end_date: nil }

          context 'direct loading' do
            it 'loads correct description respecting given actual time' do
              TimeMachine.now do
                expect(
                  goods_nomenclature.goods_nomenclature_description.pk
                ).to eq goods_nomenclature_description1.pk
              end
            end

            it 'loads correct description respecting given time' do
              TimeMachine.at(2.years.ago) do
                expect(
                  goods_nomenclature.goods_nomenclature_description.pk
                ).to eq goods_nomenclature_description1.pk
              end

              TimeMachine.at(4.years.ago) do
                expect(
                  goods_nomenclature.reload.goods_nomenclature_description.pk
                ).to eq goods_nomenclature_description2.pk
              end
            end
          end

          context 'eager loading' do
            it 'loads correct description respecting given actual time' do
              TimeMachine.now do
                expect(
                  GoodsNomenclature.where(goods_nomenclature_sid: goods_nomenclature.goods_nomenclature_sid)
                              .eager(:goods_nomenclature_descriptions)
                              .all
                              .first
                              .goods_nomenclature_description.pk
                ).to eq goods_nomenclature_description1.pk
              end
            end

            it 'loads correct description respecting given time' do
              TimeMachine.at(2.years.ago) do
                expect(
                  GoodsNomenclature.where(goods_nomenclature_sid: goods_nomenclature.goods_nomenclature_sid)
                              .eager(:goods_nomenclature_descriptions)
                              .all
                              .first
                              .goods_nomenclature_description.pk
                ).to eq goods_nomenclature_description1.pk
              end

              TimeMachine.at(4.years.ago) do
                expect(
                  GoodsNomenclature.where(goods_nomenclature_sid: goods_nomenclature.goods_nomenclature_sid)
                              .eager(:goods_nomenclature_descriptions)
                              .all
                              .first
                              .goods_nomenclature_description.pk
                ).to eq goods_nomenclature_description2.pk
              end
            end
          end
        end
      end

      context 'fetching with relevant date' do
        let!(:goods_nomenclature)                { create :goods_nomenclature, validity_start_date: 1.year.ago,
                                                                               validity_end_date: nil }
        let!(:goods_nomenclature_description1)   { create :goods_nomenclature_description,
                                                              goods_nomenclature_sid: goods_nomenclature.goods_nomenclature_sid,
                                                              validity_start_date: 2.years.ago,
                                                              validity_end_date: nil }
        let!(:goods_nomenclature_description2) { create :goods_nomenclature_description,
                                                              goods_nomenclature_sid: goods_nomenclature.goods_nomenclature_sid,
                                                              validity_start_date: 5.years.ago,
                                                              validity_end_date: 3.years.ago }
        it 'fetches correct description' do
          TimeMachine.with_relevant_validity_periods {
            expect(
              goods_nomenclature.goods_nomenclature_description.pk
            ).to eq goods_nomenclature_description1.pk
          }
        end
      end
    end

    describe 'footnote' do
      let!(:goods_nomenclature) { create :goods_nomenclature }
      let!(:footnote1)   { create :footnote, :with_gono_association,
                                              goods_nomenclature_sid: goods_nomenclature.goods_nomenclature_sid,
                                              valid_at: 2.years.ago,
                                              valid_to: nil }
      let!(:footnote2)   { create :footnote, :with_gono_association,
                                              goods_nomenclature_sid: goods_nomenclature.goods_nomenclature_sid,
                                              valid_at: 5.years.ago,
                                              valid_to: 3.years.ago }

      context 'direct loading' do
        it 'loads correct indent respecting given actual time' do
          TimeMachine.now do
            expect(
              goods_nomenclature.footnote.pk
            ).to eq footnote1.pk
          end
        end

        it 'loads correct indent respecting given time' do
          TimeMachine.at(1.year.ago) do
            expect(
              goods_nomenclature.footnote.pk
            ).to eq footnote1.pk
          end

          TimeMachine.at(4.years.ago) do
            expect(
              goods_nomenclature.reload.footnote.pk
            ).to eq footnote2.pk
          end
        end
      end

      context 'eager loading' do
        it 'loads correct indent respecting given actual time' do
          TimeMachine.now do
            expect(
              GoodsNomenclature.where(goods_nomenclature_sid: goods_nomenclature.goods_nomenclature_sid)
                          .eager(:footnotes)
                          .all
                          .first
                          .footnote.pk
            ).to eq footnote1.pk
          end
        end

        it 'loads correct indent respecting given time' do
          TimeMachine.at(1.year.ago) do
            expect(
              GoodsNomenclature.where(goods_nomenclature_sid: goods_nomenclature.goods_nomenclature_sid)
                          .eager(:footnotes)
                          .all
                          .first
                          .footnote.pk
            ).to eq footnote1.pk
          end

          TimeMachine.at(4.years.ago) do
            expect(
              GoodsNomenclature.where(goods_nomenclature_sid: goods_nomenclature.goods_nomenclature_sid)
                          .eager(:footnotes)
                          .all
                          .first
                          .footnote.pk
            ).to eq footnote2.pk
          end
        end
      end
    end

    describe 'national measurement unit set' do
      let(:gono) { create :goods_nomenclature }
      let(:tbl1) { create :tbl9, :unoq }
      let(:tbl2) { create :tbl9, :unoq }
      let(:tbl3) { create :tbl9, :unoq }
      let!(:comm1) { create :comm, cmdty_code: gono.goods_nomenclature_item_id,
                                  fe_tsmp: Date.today.ago(2.years),
                                  le_tsmp: nil,
                                  uoq_code_cdu2: tbl1.tbl_code,
                                  uoq_code_cdu3: tbl2.tbl_code }
      let!(:comm2) { create :comm, cmdty_code: gono.goods_nomenclature_item_id,
                                  fe_tsmp: Date.today.ago(5.years),
                                  le_tsmp: Date.today.ago(3.years),
                                  uoq_code_cdu2: tbl3.tbl_code }

      it 'loads associated national measurement unit set' do
        TimeMachine.at(1.year.ago) do
          nset = GoodsNomenclature.where(goods_nomenclature_sid: gono.goods_nomenclature_sid)
                        .first
                        .national_measurement_unit_set

          expect(nset.second_quantity_code).to eq tbl1.tbl_code
          expect(nset.second_quantity_description).to eq tbl1.tbl_txt

          expect(nset.third_quantity_code).to eq tbl2.tbl_code
          expect(nset.third_quantity_description).to eq tbl2.tbl_txt
        end

        TimeMachine.at(4.year.ago) do
          nset = GoodsNomenclature.where(goods_nomenclature_sid: gono.goods_nomenclature_sid)
                        .first
                        .national_measurement_unit_set

          expect(nset.second_quantity_code).to eq tbl3.tbl_code
          expect(nset.second_quantity_description).to eq tbl3.tbl_txt

          expect(nset.third_quantity_code).to be_blank
          expect(nset.third_quantity_description).to be_blank
        end
      end
    end
  end

  describe 'validations' do
    # NIG4 The start date of the goods nomenclature must be less than or equal to the end date.
    it { is_expected.to validate_validity_dates }
  end

  describe '.declarable' do
    let(:gono_80) { create(:goods_nomenclature, producline_suffix: '80') }
    let(:gono_10) { create(:goods_nomenclature, producline_suffix: '10') }

    it "should return goods_nomenclatures ony with producline_suffix == '80'" do
      gonos = described_class.declarable
      expect(gonos).to include(gono_80)
      expect(gonos).to_not include(gono_10)
    end
  end

  describe '#code' do
    let(:gono) { create(:goods_nomenclature, goods_nomenclature_item_id: '8056116321') }

    it 'should return goods_nomenclature_item_id' do
      expect(gono.code).to eq('8056116321')
    end
  end

  describe '#bti_url' do
    let(:gono) { create(:goods_nomenclature, goods_nomenclature_item_id: '8056116321') }

    it 'should include gono code' do
      expect(gono.bti_url).to include(gono.code)
    end
  end
end
