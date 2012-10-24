require 'spec_helper'

describe ExportRefundNomenclatureIndent do
  let(:erni)  { build :export_refund_nomenclature_indent }

  describe '#number_indents' do
    it 'is an alias for number_export_refund_nomenclature_indents' do
      erni.number_indents.should eq erni.number_export_refund_nomenclature_indents
    end
  end
end
