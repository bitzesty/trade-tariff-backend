require 'spec_helper'

describe Condition do
  # fields
  it { should have_fields(:condition, :document_code, :requirement, :action, :duty_expression) }

  # associations
  it { should be_embedded_in :measure }
end
