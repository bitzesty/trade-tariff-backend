######### Conformance validations 200
class FootnoteValidator < TradeTariffBackend::Validator
  validation :FO1, 'The referenced footnote type must exist.', on: [:create, :update] do
    validates :presence, of: [:footnote_type]
  end

  validation :FO2, 'The combination footnote type and code must be unique.', on: [:create, :update] do
    validates :uniqueness, of: [:footnote_type_id, :footnote_id]
  end

  validation :FO3, 'The start date must be less than or equal to the end date.', on: [:create, :update] do
    validates :validity_dates
  end

  validation :FO4, %q{At least one description record is mandatory.
    The start date of the first description period must be equal to the start date of the footnote.
    No two associated description periods may have the same start date.
    The start date must be less than or equal to the end date of the footnote.}, on: [:create, :update] do |record|
    record.footnote_description_periods.any? &&
    record.footnote_description_periods.first.validity_start_date == record.validity_start_date &&
    record.footnote_description_periods_dataset.select(:validity_start_date).group(:validity_start_date).having{count(validity_start_date) > 1}.none? &&
    (record.validity_end_date.blank? || record.footnote_description_periods.first.validity_start_date <= record.validity_end_date)
  end

  validation :FO5, 'When a footnote is used in a measure the validity period of the footnote must span the validity period of the measure.', on: [:create, :update] do |record|
    if record.measures.any?
      record.measures.all? {|measure|
        record.validity_start_date <= measure.validity_start_date &&
        ((record.validity_end_date.blank? || measure.validity_end_date.blank?) ||
          (record.validity_end_date >= measure.validity_end_date))
      }
    end
  end

  validation :FO6, 'When a footnote is used in a goods nomenclature the validity period of the footnote must span the validity period of the association with the goods nomenclature.', on: [:create, :update] do |record|
    record.footnote_association_goods_nomenclatures_dataset.where{ |o|
      (o.validity_start_date < record.validity_start_date) &
        (o.validity_end_date > record.validity_end_date)
    }.none?
  end

  validation :FO7, 'When a footnote is used in an Export refund nomenclature code the validity period of the footnote must span the validity period of the association with the Export refund code.', on: [:create, :update] do |record|
    record.footnote_association_erns_dataset.where{ |o|
      (o.validity_start_date < record.validity_start_date) &
        (o.validity_end_date > record.validity_end_date)
    }.none?
  end

  validation :FO8, 'When a footnote is used in an Additional code the validity period of the footnote must span the validity period of the association with the Additional code.', on: [:create, :update] do |record|
    record.footnote_association_additional_codes_dataset.where{ |o|
      (o.validity_start_date < record.validity_start_date) &
        (o.validity_end_date > record.validity_end_date)
    }.none?
  end

  validation :FO10, 'When a footnote is used in a Meursing Table heading the validity period of the footnote must span the validity period of the association with the Meursing heading.', on: [:create, :update] do
    validates :validity_date_span, of: :meursing_headings
  end

  validation :FO11, 'When a footnote is used in a measure then the footnote may not be deleted.', on: [:destroy] do |record|
    record.measures.none?
  end

  validation :FO12, 'When a footnote is used in a goods nomenclature then the footnote may not be deleted.', on: [:destroy] do |record|
    record.goods_nomenclatures.none?
  end

  validation :FO13, 'When a footnote is used in an Export Refund code then the footnote may not be deleted.', on: [:destroy] do |record|
    record.export_refund_nomenclatures.none?
  end

  validation :FO15, 'When a footnote is used in an additional code then the footnote may not be deleted.', on: [:destroy] do |record|
    record.additional_codes.none?
  end

  validation :FO16, 'When a footnote is used in a Meursing Table heading then the footnote may not be deleted.', on: [:destroy] do |record|
    record.meursing_headings.none?
  end

  validation :FO17, 'The validity period of the footnote type must span the validity period of the footnote.', on: [:create, :update] do
    validates :validity_date_span, of: :footnote_type
  end
end
