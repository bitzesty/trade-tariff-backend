require 'spec_helper'
require 'goods_nomenclature_mapper'

describe GoodsNomenclatureMapper do
  describe 'mapping' do

    # E.g.
    # (1) 0101000010 -
    # (2) 0101000030 --
    # (3) 0101000040 --
    # (1) should have children (2) and (3)
    # (2) should have parent (1)
    # (3) should have parent (2)
    context 'with commodity indents on the same level' do
      let(:commodity1) { create :commodity, :with_indent,
                                            indents: 1,
                                            goods_nomenclature_item_id: "0101000010" }
      let(:commodity2) { create :commodity, :with_indent,
                                            indents: 2,
                                            goods_nomenclature_item_id: "0101000030" }
      let(:commodity3) { create :commodity, :with_indent,
                                            indents: 2,
                                            goods_nomenclature_item_id: "0101000040" }

      it 'assigns no parents or children to both commodities' do
        commodities = GoodsNomenclatureMapper.new([commodity1, commodity2, commodity3])
        commodity1.children.should include commodity2
        commodity1.children.should include commodity3
        commodity1.ancestors.should be_blank
        commodity1.parent.should be_blank

        commodity2.children.should be_blank
        commodity2.ancestors.should include commodity1
        commodity2.parent.should == commodity1

        commodity3.children.should be_blank
        commodity3.ancestors.should include commodity1
        commodity3.ancestors.should_not include commodity2
        commodity3.parent.should == commodity1
      end
    end

    # E.g.
    # (1) 0101000010 -
    # (2) 0101000030 --
    # (3) 0101000110 -
    # (4) 0101000230 --
    # Expect (1) to become the child of (1).
    # Expect (3) to become the child of (4).
    context 'with commodity indents increasing' do
      let(:commodity1) { create :commodity, :with_indent,
                                            indents: 1,
                                            goods_nomenclature_item_id: "0101000010" }
      let(:commodity2) { create :commodity, :with_indent,
                                            indents: 2,
                                            goods_nomenclature_item_id: "0101000030" }
      let(:commodity3) { create :commodity, :with_indent,
                                            indents: 1,
                                            goods_nomenclature_item_id: "0101000110" }
      let(:commodity4) { create :commodity, :with_indent,
                                            indents: 2,
                                            goods_nomenclature_item_id: "0101000130" }

      it 'assigns no parents or children to both commodities' do
        commodities = GoodsNomenclatureMapper.new([commodity1, commodity2, commodity3, commodity4])
        commodity1.children.should include commodity2
        commodity1.ancestors.should be_blank
        commodity1.parent.should be_blank

        commodity2.children.should be_blank
        commodity2.ancestors.should include commodity1
        commodity2.parent.should == commodity1

        commodity3.children.should include commodity4
        commodity3.ancestors.should be_blank
        commodity3.parent.should be_blank

        commodity4.children.should be_blank
        commodity4.ancestors.should include commodity3
        commodity4.parent.should == commodity3
      end
    end

    # E.g.
    # (1) 0101000010 -
    # (2) 0101000020 --
    # (3) 0101000030 ---
    # (4) 0101000040 ---
    # (5) 0101000050 --
    # Expect (1) to have children (2) and (4)
    # Expect (2) to have children (3) and (4) and ancestor (1)
    # Expect (3) to have no children and ancestors (1) and (2)
    # Expect (4) to have no children and ancetors (1) and (2)
    # Expect (5) to have no children and ancestor (1)
    context 'with commodity indents decreasing' do
      let(:commodity1) { create :commodity, :with_indent,
                                            indents: 1,
                                            goods_nomenclature_item_id: "0101000010" }
      let(:commodity2) { create :commodity, :with_indent,
                                            indents: 2,
                                            goods_nomenclature_item_id: "0101000020" }
      let(:commodity3) { create :commodity, :with_indent,
                                            indents: 3,
                                            goods_nomenclature_item_id: "0101000030" }
      let(:commodity4) { create :commodity, :with_indent,
                                            indents: 3,
                                            goods_nomenclature_item_id: "0101000040" }
      let(:commodity5) { create :commodity, :with_indent,
                                            indents: 2,
                                            goods_nomenclature_item_id: "0101000050" }

      it 'assigns no parents or children to both commodities' do
        commodities = GoodsNomenclatureMapper.new([commodity1, commodity2, commodity3, commodity4, commodity5])
        commodity1.children.should include commodity2
        commodity1.children.should include commodity5
        commodity1.ancestors.should be_blank
        commodity1.parent.should be_blank

        commodity2.children.should include commodity3
        commodity2.ancestors.should include commodity1
        commodity2.parent.should == commodity1

        commodity3.children.should be_blank
        commodity3.ancestors.should include commodity1
        commodity3.ancestors.should include commodity2
        commodity3.parent.should == commodity2

        commodity4.children.should be_blank
        commodity4.ancestors.should include commodity1
        commodity4.ancestors.should include commodity2
        commodity4.parent.should == commodity2

        commodity5.children.should be_blank
        commodity5.ancestors.should include commodity1
        commodity5.parent.should == commodity1
      end
    end

    # E.g.
    # (1) 0101000010 10
    # (2) 0101000010 80 -
    # (3) 0101000030 10
    # (4) 0101000030 80 -
    # (1) should have children (2)
    # (2) should have parent (1)
    # (3) should have children (4)
    # (4) should have parent (3)
    context 'with heading indents on the same level' do
      let(:heading1) { create :heading, :with_indent,
                                        indents: 0,
                                        goods_nomenclature_item_id: "0101000000",
                                        producline_suffix: "10" }
      let(:heading2) { create :heading, :with_indent,
                                        indents: 1,
                                        goods_nomenclature_item_id: "0101000000",
                                        producline_suffix: "80" }
      let(:heading3) { create :heading, :with_indent,
                                        indents: 0,
                                        goods_nomenclature_item_id: "0102000000",
                                        producline_suffix: "10" }
      let(:heading4) { create :heading, :with_indent,
                                        indents: 0,
                                        goods_nomenclature_item_id: "0102000000",
                                        producline_suffix: "80" }

      it 'assigns no parents or children to both commodities' do
        headings = GoodsNomenclatureMapper.new([heading1, heading2, heading3, heading4])
        heading1.children.should include heading2
        heading1.children.should_not include heading3
        heading1.ancestors.should be_blank
        heading1.parent.should be_blank

        heading2.children.should be_blank
        heading2.ancestors.should include heading1
        heading2.parent.should == heading1

        heading3.children.should include heading4
        heading3.ancestors.should be_blank
        heading3.parent.should be_blank

        heading4.children.should be_blank
        heading4.ancestors.should include heading3
        heading4.ancestors.should_not include heading1
        heading4.parent.should == heading3
      end
    end
  end
end
