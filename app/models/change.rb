class Change
  attr_accessor :model, :oid, :operation_date, :operation

  def initialize(attributes = {})
    attributes.each do |attribute, value|
      public_send("#{attribute}=", value) if respond_to?("#{attribute}=")
    end
  end
end
