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
end

# TODO: GA3
# TODO: GA5
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
