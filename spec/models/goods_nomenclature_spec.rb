require 'spec_helper'

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
              goods_nomenclature.goods_nomenclature_indent.pk.should == goods_nomenclature_indent1.pk
            end
          end

          it 'loads correct indent respecting given time' do
            TimeMachine.at(1.year.ago) do
              goods_nomenclature.goods_nomenclature_indent.pk.should == goods_nomenclature_indent1.pk
            end

            TimeMachine.at(4.years.ago) do
              goods_nomenclature.reload.goods_nomenclature_indent.pk.should == goods_nomenclature_indent3.pk
            end
          end
        end

        context 'eager loading' do
          it 'loads correct indent respecting given actual time' do
            TimeMachine.now do
              GoodsNomenclature.where(goods_nomenclature_sid: goods_nomenclature.goods_nomenclature_sid)
                            .eager(:goods_nomenclature_indents)
                            .all
                            .first
                            .goods_nomenclature_indent.pk.should == goods_nomenclature_indent1.pk
            end
          end

          it 'loads correct indent respecting given time' do
            TimeMachine.at(1.year.ago) do
              GoodsNomenclature.where(goods_nomenclature_sid: goods_nomenclature.goods_nomenclature_sid)
                            .eager(:goods_nomenclature_indents)
                            .all
                            .first
                            .goods_nomenclature_indent.pk.should == goods_nomenclature_indent1.pk
            end

            TimeMachine.at(4.years.ago) do
              GoodsNomenclature.where(goods_nomenclature_sid: goods_nomenclature.goods_nomenclature_sid)
                            .eager(:goods_nomenclature_indents)
                            .all
                            .first
                            .goods_nomenclature_indent.pk.should == goods_nomenclature_indent3.pk
            end
          end
        end
      end

      context 'fetching with relevant date' do
        let!(:goods_nomenclature)                { create :goods_nomenclature, validity_start_date: 1.year.ago,
                                                                               validity_end_date: nil }
        let!(:goods_nomenclature_indent1)        { create :goods_nomenclature_indent,
                                                                    goods_nomenclature_sid: goods_nomenclature.goods_nomenclature_sid,
                                                                    validity_start_date: 2.years.ago,
                                                                    validity_end_date: nil }
        let!(:goods_nomenclature_indent2)        { create :goods_nomenclature_indent,
                                                              goods_nomenclature_sid: goods_nomenclature.goods_nomenclature_sid,
                                                              validity_start_date: 6.years.ago,
                                                              validity_end_date: 3.years.ago }
        it 'fetches correct gono indent' do
          TimeMachine.with_relevant_validity_periods {
            goods_nomenclature.goods_nomenclature_indent.pk.should eq goods_nomenclature_indent1.pk
          }
        end
      end
    end

    describe 'goods nomenclature description' do
      context 'fetching with absolute date' do
        context 'at least one end date present' do
          let!(:goods_nomenclature)                { create :goods_nomenclature }
          let!(:goods_nomenclature_description1)   { create :goods_nomenclature_description,
                                                                goods_nomenclature_sid: goods_nomenclature.goods_nomenclature_sid,
                                                                valid_at: 2.years.ago,
                                                                valid_to: nil }
          let!(:goods_nomenclature_description2) { create :goods_nomenclature_description,
                                                                goods_nomenclature_sid: goods_nomenclature.goods_nomenclature_sid,
                                                                valid_at: 5.years.ago,
                                                                valid_to: 3.years.ago }

          context 'direct loading' do
            it 'loads correct description respecting given actual time' do
              TimeMachine.now do
                goods_nomenclature.goods_nomenclature_description.pk.should == goods_nomenclature_description1.pk
              end
            end

            it 'loads correct description respecting given time' do
              TimeMachine.at(1.year.ago) do
                goods_nomenclature.goods_nomenclature_description.pk.should == goods_nomenclature_description1.pk
              end

              TimeMachine.at(4.years.ago) do
                goods_nomenclature.reload.goods_nomenclature_description.pk.should == goods_nomenclature_description2.pk
              end
            end
          end

          context 'eager loading' do
            it 'loads correct description respecting given actual time' do
              TimeMachine.now do
                GoodsNomenclature.where(goods_nomenclature_sid: goods_nomenclature.goods_nomenclature_sid)
                              .eager(:goods_nomenclature_descriptions)
                              .all
                              .first
                              .goods_nomenclature_description.pk.should == goods_nomenclature_description1.pk
              end
            end

            it 'loads correct description respecting given time' do
              TimeMachine.at(1.year.ago) do
                GoodsNomenclature.where(goods_nomenclature_sid: goods_nomenclature.goods_nomenclature_sid)
                              .eager(:goods_nomenclature_descriptions)
                              .all
                              .first
                              .goods_nomenclature_description.pk.should == goods_nomenclature_description1.pk
              end

              TimeMachine.at(4.years.ago) do
                GoodsNomenclature.where(goods_nomenclature_sid: goods_nomenclature.goods_nomenclature_sid)
                              .eager(:goods_nomenclature_descriptions)
                              .all
                              .first
                              .goods_nomenclature_description.pk.should == goods_nomenclature_description2.pk
              end
            end
          end
        end

        context 'blank end dates' do
          let!(:goods_nomenclature)                { create :goods_nomenclature }
          let!(:goods_nomenclature_description1)   { create :goods_nomenclature_description,
                                                                goods_nomenclature_sid: goods_nomenclature.goods_nomenclature_sid,
                                                                valid_at: 3.years.ago,
                                                                valid_to: nil }
          let!(:goods_nomenclature_description2) { create :goods_nomenclature_description,
                                                                goods_nomenclature_sid: goods_nomenclature.goods_nomenclature_sid,
                                                                valid_at: 5.years.ago,
                                                                valid_to: nil }

          context 'direct loading' do
            it 'loads correct description respecting given actual time' do
              TimeMachine.now do
                goods_nomenclature.goods_nomenclature_description.pk.should == goods_nomenclature_description1.pk
              end
            end

            it 'loads correct description respecting given time' do
              TimeMachine.at(2.years.ago) do
                goods_nomenclature.goods_nomenclature_description.pk.should == goods_nomenclature_description1.pk
              end

              TimeMachine.at(4.years.ago) do
                goods_nomenclature.reload.goods_nomenclature_description.pk.should == goods_nomenclature_description2.pk
              end
            end
          end

          context 'eager loading' do
            it 'loads correct description respecting given actual time' do
              TimeMachine.now do
                GoodsNomenclature.where(goods_nomenclature_sid: goods_nomenclature.goods_nomenclature_sid)
                              .eager(:goods_nomenclature_descriptions)
                              .all
                              .first
                              .goods_nomenclature_description.pk.should == goods_nomenclature_description1.pk
              end
            end

            it 'loads correct description respecting given time' do
              TimeMachine.at(2.years.ago) do
                GoodsNomenclature.where(goods_nomenclature_sid: goods_nomenclature.goods_nomenclature_sid)
                              .eager(:goods_nomenclature_descriptions)
                              .all
                              .first
                              .goods_nomenclature_description.pk.should == goods_nomenclature_description1.pk
              end

              TimeMachine.at(4.years.ago) do
                GoodsNomenclature.where(goods_nomenclature_sid: goods_nomenclature.goods_nomenclature_sid)
                              .eager(:goods_nomenclature_descriptions)
                              .all
                              .first
                              .goods_nomenclature_description.pk.should == goods_nomenclature_description2.pk
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
                                                              valid_at: 2.years.ago,
                                                              valid_to: nil }
        let!(:goods_nomenclature_description2) { create :goods_nomenclature_description,
                                                              goods_nomenclature_sid: goods_nomenclature.goods_nomenclature_sid,
                                                              valid_at: 5.years.ago,
                                                              valid_to: 3.years.ago }
        it 'fetches correct description' do
          TimeMachine.with_relevant_validity_periods {
            goods_nomenclature.goods_nomenclature_description.pk.should eq goods_nomenclature_description1.pk
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
            goods_nomenclature.footnote.pk.should == footnote1.pk
          end
        end

        it 'loads correct indent respecting given time' do
          TimeMachine.at(1.year.ago) do
            goods_nomenclature.footnote.pk.should == footnote1.pk
          end

          TimeMachine.at(4.years.ago) do
            goods_nomenclature.reload.footnote.pk.should == footnote2.pk
          end
        end
      end

      context 'eager loading' do
        it 'loads correct indent respecting given actual time' do
          TimeMachine.now do
            GoodsNomenclature.where(goods_nomenclature_sid: goods_nomenclature.goods_nomenclature_sid)
                          .eager(:footnotes)
                          .all
                          .first
                          .footnote.pk.should == footnote1.pk
          end
        end

        it 'loads correct indent respecting given time' do
          TimeMachine.at(1.year.ago) do
            GoodsNomenclature.where(goods_nomenclature_sid: goods_nomenclature.goods_nomenclature_sid)
                          .eager(:footnotes)
                          .all
                          .first
                          .footnote.pk.should == footnote1.pk
          end

          TimeMachine.at(4.years.ago) do
            GoodsNomenclature.where(goods_nomenclature_sid: goods_nomenclature.goods_nomenclature_sid)
                          .eager(:footnotes)
                          .all
                          .first
                          .footnote.pk.should == footnote2.pk
          end
        end
      end
    end
  end

  describe 'validations' do
    # NIG4 The start date of the goods nomenclature must be less than or equal to the end date.
    it { should validate_validity_dates }
  end
end
