require 'spec_helper'

describe Condition do
  # fields
  it { should have_fields(:name, :document_code, :action, :duty_expression) }

  # associations
  it { should have_and_belong_to_many :measures }

  # misc
  it { should be_timestamped_document }
end
