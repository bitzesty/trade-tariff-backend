class FootnoteType < Sequel::Model
  set_primary_key  :footnote_type_id

  one_to_many :footnotes

  ######### Conformance validations 100

  validates do
    # FOT1
    uniqueness_of :footnote_type_id
    # FOT3
    validity_dates
  end

  def before_destroy
    # FOT2
    return !footnotes.any?

    super
  end
end

