class CreateSearchReference
  def self.create(search_reference_params)
    new(search_reference_params).call
  end

  attr_writer :search_index

  def initialize(search_reference_params = {})
    @search_reference = SearchReference.new(search_reference_params)
  end

  def call
    if @search_reference.save
      search_index.for(@search_reference).store
    end

    @search_reference
  end

  private

  def search_index
    @search_index || TradeTariffBackend::SearchIndex
  end
end
