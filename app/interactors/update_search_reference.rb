class UpdateSearchReference
  def self.update(search_reference, search_reference_params)
    new(search_reference, search_reference_params).call
  end

  attr_writer :search_client

  def initialize(search_reference, search_reference_params = {})
    @search_reference = search_reference
    @search_reference_params = search_reference_params
  end

  def call
    @search_reference.set(@search_reference_params)

    if @search_reference.save
      search_client.index(@search_reference)
    end

    @search_reference
  end

  private

  def search_client
    @search_client || TradeTariffBackend.search_client
  end
end
