require 'spec_helper'

describe NationalMeasurementUnitSet do
  describe "#national_measurement_unit_set_units" do
    let(:tbl1) { create :tbl9, :unoq }
    let(:tbl2) { create :tbl9, :unoq }
    let(:comm) { create :comm, uoq_code_cdu2: tbl1.tbl_code,
                               uoq_code_cdu3: tbl2.tbl_code }

    let(:nmus) { NationalMeasurementUnitSet.where(cmdty_code: comm.cmdty_code).first }

    it 'builds array of national measurement units' do
      nmus.national_measurement_unit_set_units.should be_kind_of Array
    end

    it 'should include national measurement units' do
      nmus.national_measurement_unit_set_units.all?{ |nmusu| nmusu.is_a?(NationalMeasurementUnit) }
    end

    it 'should set second national measurement unit code/description to comm uoq_code_cdu2' do
      nmusu = nmus.national_measurement_unit_set_units.first
      nmusu.measurement_unit_code.should eq tbl1.tbl_code
      nmusu.description.should eq tbl1.tbl_txt
      nmusu.level.should eq 2
    end

    it 'should set second national measurement unit code/description to comm uoq_code_cdu3' do
      nmusu = nmus.national_measurement_unit_set_units.last
      nmusu.measurement_unit_code.should eq tbl2.tbl_code
      nmusu.description.should eq tbl2.tbl_txt
      nmusu.level.should eq 3
    end
  end
end
