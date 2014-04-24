######### Conformance validations 250
class GeographicalAreaValidator < TradeTariffBackend::Validator
  validation :GA1, 'The combination geographical area id + validity start date must be unique.', on: [:create, :update] do
    validates :uniqueness, of: [:geographical_area_id, :validity_start_date]
  end

  validation :GA2, 'The start date must be less than or equal to the end date.' do
    validates :validity_dates
  end

  validation :GA4, 'The referenced parent geographical area group must be an existing geographical area with area code = 1 (geographical area group)', on: [:create, :update] do |record|
    parent_sid = record.parent_geographical_area_group_sid
    if parent_sid.present?
      parent = record.class[geographical_area_sid: parent_sid]
      parent.try(:geographical_code).to_s == "1"
    end
  end

  validation :GA5, 'If a geographical area has a parent geographical area group then the validity period of the parent geographical area group must span the validity period of the geographical area', on: [:create, :update] do |record|
    if record.parent_geographical_area.present?
      parent = record.parent_geographical_area
      # It's not complaining if start or end dates aren't present
      @has_error = if record.validity_start_date and parent.validity_start_date
        parent.validity_start_date > record.validity_start_date
      end
      @has_error ||= if record.validity_end_date and parent.validity_end_date
        parent.validity_end_date < record.validity_end_date
      end
      !@has_error
    end
  end
end

# TODO: GA3
# TODO: GA6
# TODO: GA7
# TODO: GA10
# TODO: GA11
# TODO: GA12
# TODO: GA13
# TODO: GA14
# TODO: GA15
# TODO: GA16
# TODO: GA17
# TODO: GA18
# TODO: GA19
# TODO: GA20
# TODO: GA21
# TODO: GA22
# TODO: GA23
