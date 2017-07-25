module CodesMappingHelper
  def stub_codes_mapping_data
    res = [
      ['10101111', '22101122'],
      ['10101112', '22101133']
    ].to_h
    allow(SearchService::CodesMapping).to receive(:data).and_return(res)
  end
end
