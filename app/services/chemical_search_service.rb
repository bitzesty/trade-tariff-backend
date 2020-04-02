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
    result = fetch_by_cas || fetch_by_name

    result
  end

  private

  def fetch_by_cas
    return unless cas

    @chemicals = Chemical.where(cas: cas)
    custom_paginator(@chemicals)
  end

  def fetch_by_name
    return unless name

    @chemicals = ChemicalName.where(Sequel.like(:name, "%#{name}%")).map(&:chemical).uniq
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
end
