class FootnoteType < Sequel::Model
  set_primary_key  :footnote_type_id

  one_to_many :footnotes

  ######### Conformance validations 100
  def validate
    super
    # FOT1
    validates_unique :footnote_type_id
    # FOT3
    validates_start_date
  end

  def before_destroy
    # FOT2
    return !footnotes.any?

    super
  end
end

