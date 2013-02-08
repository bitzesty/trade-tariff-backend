######### Conformance validations 100
class FootnoteTypeValidator < TradeTariffBackend::Validator
  validation :FOT1, 'The type of the footnote must be unique.', on: [:create, :update] do
    validates :uniqueness, of: :footnote_type_id
  end

  validation :FOT2, 'should not allow footnote_type deletion when have associated footnotes', on: [:destroy] do |record|
    record.footnotes.none?
  end

  validation :FOT3, 'The start date must be less than or equal to the end date.' do
    validates :validity_dates
  end
end
