require 'sequel/extensions/pagination_compat'

Sequel.extension     :pagination_compat
Sequel::Model.plugin :take
Sequel::Model.plugin :validation_helpers
Sequel::Model.plugin :tariff_validation_helpers

