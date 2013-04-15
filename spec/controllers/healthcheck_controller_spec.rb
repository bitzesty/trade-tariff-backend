require 'spec_helper'

describe HealthcheckController, "GET #index" do
  it 'tries to fetch section index' do
    Section.should_receive(:all).and_return(true)

    get :index
  end

  it 'returns current release sha' do
    get :index

    response.body.should match_json_expression({ git_sha1: String })
  end
end
