require "rails_helper"

describe "Auditable sequel plugin" do
  let(:model_with_plugin) { create :section_note, content: "first content" }

  describe "Model hooks" do
    it "creates an audit record when updated" do
      expect {
        model_with_plugin.update(content: "test")
      }.to change { Audit.count }.by(1)
    end

    it "the new audit record created keeps the record of the changes" do
      model_with_plugin.update(content: "second content")
      result = JSON.parse(model_with_plugin.audits.last.changes)
      
      expect(result["content"][0]).to eq("first content")
      expect(result["content"][1]).to eq("second content")
    end
  end

  describe 'Chemical model is auditable' do
    let(:cas0)      { '12-34-56' }
    let(:cas1)      { '34-56-12' }
    let(:cas2)      { '56-12-34' }
    let(:chemical)  { create :chemical, cas: cas0 }

    it 'creates an audit record when chemical updated' do
      expect { chemical.update(cas: cas1) }.to change { Audit.count }.by(1)
    end

    it 'the new audit record created keeps the record of the changes to chemical' do
      chemical.update(cas: cas2)
      result = JSON.parse(chemical.audits.last.changes)

      expect(result['cas'][0]).to eq(cas0)
      expect(result['cas'][1]).to eq(cas2)
    end
  end
end
