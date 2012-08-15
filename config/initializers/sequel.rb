require 'sequel/extensions/pagination_compat'

Sequel::Model.plugin :take

# Defaults for sensible migrations
Sequel::MySQL.default_engine = 'InnoDB'
Sequel::MySQL.default_charset = 'utf8'
