require "rails_helper"
require "gds-sso/lint/user_spec"

describe User do
  describe "gds-sso" do
    it_behaves_like "a gds-sso user class"
  end

  describe "#update_attributes" do
    let!(:user) { create :user }
    let(:attrs) {
      attributes_for :user
    }

    before {
      user.update_attributes(attrs)
      user.reload
    }

    it {
      expect(user.name).to eq(attrs[:name])
      expect(user.email).to eq(attrs[:email])
    }
  end

  describe "#create!" do
    describe "valid" do
      let(:attrs) {
        attributes_for :user
      }

      it {
        expect {
          User.create!(attrs)
        }.to change{ User.count }.by(1)
      }
    end

    describe "invalid" do
      let!(:user) { create :user }
      let(:attrs) {
        attributes_for(:user).merge(
          id: user.id
        )
      }

      it {
        expect {
          User.create!(attrs)
        }.to raise_error(Sequel::Error)
      }
    end
  end
end
