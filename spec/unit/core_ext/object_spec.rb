describe Object do
  describe '#tap!' do
    it 'returns self if block results in nil' do
      'a'.tap!{ nil }.should == 'a'
    end

    it 'returns block result if block does not result in nil' do
      'a'.tap!{'b'}.should == 'b'
    end
  end
end
