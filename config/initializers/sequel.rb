require 'sequel/extensions/pagination_compat'
require 'sequel/extensions/db_lock'

# Defaults for sensible migrations
Sequel::MySQL.default_engine = 'InnoDB'
Sequel::MySQL.default_charset = 'utf8'

Sequel::Model.plugin :take
# Sequel::Model.plugin :validation_helpers
Sequel::Model.plugin :validation_class_methods
Sequel::Model.plugin :tariff_validation_helpers
