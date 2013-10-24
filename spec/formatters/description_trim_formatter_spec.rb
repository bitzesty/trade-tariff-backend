require 'spec_helper'
require 'description_trim_formatter'

describe DescriptionTrimFormatter do
  describe '.format' do
    it 'replaces | with empty space' do
      DescriptionTrimFormatter.format(description: '|').should eq ' '
    end

    it 'strips !1!' do
      DescriptionTrimFormatter.format(description: '!1!').should eq ''
    end

    it 'strips !X!' do
      DescriptionTrimFormatter.format(description: '!X!').should eq ''
    end

    it 'strips !x!' do
      DescriptionTrimFormatter.format(description: '!x!').should eq ''
    end

    it 'strips !o!' do
      DescriptionTrimFormatter.format(description: '!o!').should eq ''
    end

    it 'strips !O!' do
      DescriptionTrimFormatter.format(description: '!O!').should eq ''
    end

    it 'strips !>=!' do
      DescriptionTrimFormatter.format(description: '!>=!').should eq ''
    end

    it 'strips !<=!' do
      DescriptionTrimFormatter.format(description: '!<=!').should eq ''
    end

    it 'replaces  @<anycharacter> with <anycharacter>' do
      DescriptionTrimFormatter.format(description: '@1').should eq '1'
    end

    it 'replaces $<anycharacter> with <anycharacter>' do
      DescriptionTrimFormatter.format(description: '$1').should eq '1'
    end
  end
end
