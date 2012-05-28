require 'spec_helper'

describe LegalAct do
  # fields
  it { should have_fields(:code) }

  # associations
  it { should have_many :measures }

  # misc
  it { should be_timestamped_document }

  describe "#url" do
    let(:number) { Forgery(:basic).text(exactly: 5) }
    let(:subnumber) { Forgery(:basic).text(exactly: 2)}
    let(:legal_act) { build :legal_act, code: "#{number}/#{subnumber}" }

    it 'returns url to the relevant EU act for the measure' do
      legal_act.url.should == "http://eur-lex.europa.eu/LexUriServ/LexUriServ.do?uri=CELEX:320#{subnumber}#{number}:en:HTML"
    end
  end
end
