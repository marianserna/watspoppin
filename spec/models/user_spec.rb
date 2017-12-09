require 'rails_helper'

RSpec.describe User, type: :model do

  context "passes validations" do

    let(:user) {FactoryBot.create(:user)}

    it "passes with valid attributes" do
      expect(user).to be_valid
    end

    it "is not valid without a name" do
      user.name = nil
      expect(user).to_not be_valid
    end

    it "is not valid without a email" do
      user.email = nil
      expect(user).to_not be_valid
    end

    it "is not valid without a password" do
      user.password = nil
      expect(user).to_not be_valid
    end
  end

  describe "Associations" do
    # let(:user) {FactoryBot.create(:user)}

    it "has many stories" do
      assc = User.reflect_on_association(:stories)
      expect(assc.macro).to eq(:has_many)
    end

    it "has has_many services" do
      assc = User.reflect_on_association(:services)
      expect(assc.macro).to eq(:has_many)
    end
  end

end
