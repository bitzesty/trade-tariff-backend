class DestroySearchReference
  def self.destroy(search_reference)
    new(search_reference).call
  end

  attr_writer :search_client

  def initialize(search_reference = {})
    @search_reference = search_reference
  end

  def call
    @search_reference.destroy
    search_client.delete(@search_reference)

    @search_reference
  end

  private

  def search_client
    @search_client || TradeTariffBackend.search_client
  end
end
