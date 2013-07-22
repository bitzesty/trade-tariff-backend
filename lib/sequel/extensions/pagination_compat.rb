# Plugin is based on default sequel pagination extension
# see https://github.com/jeremyevans/sequel/blob/master/lib/sequel/extensions/pagination.rb
# Adds a Kaminari compatible API so it can be used with Tire.

require 'sequel/extensions/pagination'

Sequel::Model.db.extension :pagination

module Sequel
  module PaginationExtension
    extend ActiveSupport::Concern

    included do
      def paginate_with_kaminari(paginate_query, page_size=nil, record_count=nil)
        if paginate_query.is_a?(Hash)
          paginate_without_kaminari(paginate_query[:page], paginate_query[:per_page], record_count)
        elsif paginate_query.is_a?(Integer)
          paginate_without_kaminari(paginate_query, page_size, record_count)
        end
      end

      alias_method_chain :paginate, :kaminari
    end
  end
end

Sequel::DatasetPagination.send :include, Sequel::PaginationExtension
