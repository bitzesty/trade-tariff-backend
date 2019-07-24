class MeasurementUnitAbbreviation < Sequel::Model
  one_to_one :measurement_unit, primary_key: :measurement_unit_code,
                                key: :measurement_unit_code
end

# NOTE: if the measurement unit abbreviations are changed,
#       then we also need to update the UKTT gem
#       in the private and public repos.
#       The gem uses these abbreviations in producing PDFs.
#       UKTT gem private repo: https://gitlab.bitzesty.com/clients/trade-tariff/uktt
#       UKTT gem public repo: https://github.com/mcumcu/uktt.git
