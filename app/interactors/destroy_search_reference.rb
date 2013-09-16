class DestroySearchReference
  def self.destroy(search_reference)
    new(search_reference).call
  end

  attr_writer :search_index

  def initialize(search_reference = {})
    @search_reference = search_reference
  end

  def call
    @search_reference.destroy
    search_index.for(@search_reference).remove

    @search_reference
  end

  private

  def search_index
    @search_index || TradeTariffBackend::SearchIndex
  end
end
