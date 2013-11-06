require 'spec_helper'
require 'description_formatter'

describe DescriptionFormatter do
  describe '.format' do
    it 'replaces & with ampersands' do
      description = 'bread & butter'

      DescriptionFormatter.format(description: description).should eq 'bread &amp; butter'
    end

    it 'does not replace & followed with # (html entity)' do
      description = '&#39;A&#39; with an &#39;X&#39;'

      DescriptionFormatter.format(description: description).should eq description
    end

    it 'does not replace & followed by nbsp (non breaking space entity)' do
      description = 'a&nbsp;paragraph'

      DescriptionFormatter.format(description: description).should eq description
    end

    it 'replaces | with non breaking space html entity' do
      DescriptionFormatter.format(description: ' | ').should eq ' &nbsp; '
    end

    it 'replaces !1! with breaking space tags' do
      DescriptionFormatter.format(description: ' !1! ').should eq ' <br /> '
    end

    it 'replaces !X! with times html entity' do
      DescriptionFormatter.format(description: ' !X! ').should eq ' &times; '
    end

    it 'replaces !x! with times html entity' do
      DescriptionFormatter.format(description: ' !x! ').should eq ' &times; '
    end

    it 'replaces !o! with deg html entity' do
      DescriptionFormatter.format(description: ' !o! ').should eq ' &deg; '
    end

    it 'replaces !O! with deg html entity' do
      DescriptionFormatter.format(description: ' !O! ').should eq ' &deg; '
    end

    it 'replaces !>=! with greater or equals html entity' do
      DescriptionFormatter.format(description: ' !>=! ').should eq ' &ge; '
    end

    it 'replaces !<=! with less or equal html entity' do
      DescriptionFormatter.format(description: ' !<=! ').should eq ' &le; '
    end

    it 'replaces and wraps @<anycharacter> with html sub tag' do
      DescriptionFormatter.format(description: ' @1 ').should eq ' <sub>1</sub> '
    end

    it 'replaces and wraps $<anycharacter> with html sup tag' do
      DescriptionFormatter.format(description: ' $1 ').should eq ' <sup>1</sup> '
    end
  end
end
