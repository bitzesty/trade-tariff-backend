class ChemicalSearchService
  attr_reader :cas, :name
  attr_reader :current_page, :per_page, :pagination_record_count

  def initialize(attributes, current_page, per_page)
    @cas = attributes['cas']
    @name = attributes['name']
    @current_page = current_page
    @per_page = per_page
    @pagination_record_count = 0
  end

  def perform
    fetch_by_cas || fetch_by_name
  end

  private

  def fetch_by_cas
    return unless cas = cas_cleaned

    @chemicals = Rails.cache.fetch(cache_id, expires_in: cache_expiry) do
      Chemical.where(Sequel.like(:cas, "%#{cas}%")).all
    end
    Rails.cache.delete(cache_id) unless @chemicals.present?
    custom_paginator(@chemicals)
  end

  def fetch_by_name
    return unless name

    @chemicals = Rails.cache.fetch(cache_id, expires_in: cache_expiry) do
      ChemicalName.where(Sequel.like(:name, "%#{name}%")).map(&:chemical).uniq
    end
    Rails.cache.delete(cache_id) unless @chemicals.present?
    custom_paginator(@chemicals)
  end

  def custom_paginator(result)
    start = (current_page - 1) * per_page
    finish = start + per_page
    @pagination_record_count = result.count

    result.to_a[start..finish] || []
  end

  def result_count(result)
    @pagination_record_count = result.count
    result
  end

  def cache_id
    "chemical-search-#{(cas_cleaned.presence || name.presence)}"
  end

  def cache_expiry(seconds = nil)
    seconds || TradeTariffBackend.seconds_till_6am
  end

  def cas_cleaned
    return unless @cas

    if m = /\A(cas\s*.*?\s*)?(\d+-\d+-\d{1}).*\z/i.match(term)
      # ^ Extract the CAS number from a string
      # - may be just the CAS number alone, e.g. `10310-21-1`
      # - optional leading 'cas', with or without spaces after, e.g. `cas 10310-21-1`
      # - optional other text between the leading 'cas' and the CAS number. e.g. `cas rn 10310-21-1`
      # - optional other text before and/or after the CAS number. e.g. `cas rn blah 10310-21-1foobar biz baz   other text`
      # - additional digits after the CAS number are ignored. Note: CAS numbers always end in a dash, then a single digit (`-\d{1}`) e.g. `10310-21-1684984654687` is interpreted as `10310-21-1`
      m[2]
    end
  end
end
