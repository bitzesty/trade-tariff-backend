class Change
  attr_accessor :model, :oid, :operation_date, :operation

  def initialize(attributes = {})
    attributes.each do |attribute, value|
      public_send("#{attribute}=", value) if respond_to?("#{attribute}=")
    end
  end

  def operation_record
    @operation_record ||= operation_class.find(oid: oid)
  end

  def record
    operation_record.record
  end

  private

  def operation_class
    "#{model}::Operation".constantize
  end
end
