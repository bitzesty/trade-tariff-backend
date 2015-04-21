require 'rails_helper'
require 'description_trim_formatter'

describe DescriptionTrimFormatter do
  describe '.format' do
    it 'replaces | with empty space' do
      expect(
        DescriptionTrimFormatter.format(description: '|')
      ).to eq ' '
    end

    it 'strips !1!' do
      expect(
        DescriptionTrimFormatter.format(description: '!1!')
      ).to eq ''
    end

    it 'strips !X!' do
      expect(
        DescriptionTrimFormatter.format(description: '!X!')
      ).to eq ''
    end

    it 'strips !x!' do
      expect(
        DescriptionTrimFormatter.format(description: '!x!')
      ).to eq ''
    end

    it 'strips !o!' do
      expect(
        DescriptionTrimFormatter.format(description: '!o!')
      ).to eq ''
    end

    it 'strips !O!' do
      expect(
        DescriptionTrimFormatter.format(description: '!O!')
      ).to eq ''
    end

    it 'strips !>=!' do
      expect(
        DescriptionTrimFormatter.format(description: '!>=!')
      ).to eq ''
    end

    it 'strips !<=!' do
      expect(
        DescriptionTrimFormatter.format(description: '!<=!')
      ).to eq ''
    end

    it 'replaces  @<anycharacter> with <anycharacter>' do
      expect(
        DescriptionTrimFormatter.format(description: '@1')
      ).to eq '1'
    end

    it 'replaces $<anycharacter> with <anycharacter>' do
      expect(
        DescriptionTrimFormatter.format(description: '$1')
      ).to eq '1'
    end
  end
end
