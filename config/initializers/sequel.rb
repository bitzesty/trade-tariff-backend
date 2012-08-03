require 'sequel/extensions/pagination_compat'

Sequel.extension     :pagination_compat
Sequel::Model.plugin :take
