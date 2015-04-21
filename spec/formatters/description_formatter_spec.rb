require 'rails_helper'
require 'description_formatter'

describe DescriptionFormatter do
  describe '.format' do
    it 'replaces & with ampersands' do
      description = 'bread & butter'

      expect(
        DescriptionFormatter.format(description: description)
      ).to eq 'bread &amp; butter'
    end

    it 'does not replace & followed with # (html entity)' do
      description = '&#39;A&#39; with an &#39;X&#39;'

      expect(
        DescriptionFormatter.format(description: description)
      ).to eq description
    end

    it 'does not replace & followed by nbsp (non breaking space entity)' do
      description = 'a&nbsp;paragraph'

      expect(
        DescriptionFormatter.format(description: description)
      ).to eq description
    end

    it 'replaces | with non breaking space html entity' do
      expect(
        DescriptionFormatter.format(description: ' | ')
      ).to eq ' &nbsp; '
    end

    it 'replaces !1! with breaking space tags' do
      expect(
        DescriptionFormatter.format(description: ' !1! ')
      ).to eq ' <br /> '
    end

    it 'replaces !X! with times html entity' do
      expect(
        DescriptionFormatter.format(description: ' !X! ')
      ).to eq ' &times; '
    end

    it 'replaces !x! with times html entity' do
      expect(
        DescriptionFormatter.format(description: ' !x! ')
      ).to eq ' &times; '
    end

    it 'replaces !o! with deg html entity' do
      expect(
        DescriptionFormatter.format(description: ' !o! ')
      ).to eq ' &deg; '
    end

    it 'replaces !O! with deg html entity' do
      expect(
        DescriptionFormatter.format(description: ' !O! ')
      ).to eq ' &deg; '
    end

    it 'replaces !>=! with greater or equals html entity' do
      expect(
        DescriptionFormatter.format(description: ' !>=! ')
      ).to eq ' &ge; '
    end

    it 'replaces !<=! with less or equal html entity' do
      expect(
        DescriptionFormatter.format(description: ' !<=! ')
      ).to eq ' &le; '
    end

    it 'replaces and wraps @<anycharacter> with html sub tag' do
      expect(
        DescriptionFormatter.format(description: ' @1 ')
      ).to eq ' <sub>1</sub> '
    end

    it 'replaces and wraps $<anycharacter> with html sup tag' do
      expect(
        DescriptionFormatter.format(description: ' $1 ')
      ).to eq ' <sup>1</sup> '
    end
  end
end
