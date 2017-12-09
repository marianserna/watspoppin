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

    it "has many stories" do
      assc = User.reflect_on_association(:stories)
      expect(assc.macro).to eq(:has_many)
    end

    it "has has_many services" do
      assc = User.reflect_on_association(:services)
      expect(assc.macro).to eq(:has_many)
    end
  end

  describe "post a " do

    before(:each) do

    end

    let(:user) {FactoryBot.create(:user)}
    let(:service) {FactoryBot.create(:service)}
    it "tweet" do

      client = instance_double(Twitter::REST::Client, {
        update: "This is a Tweet!"
        })
      # client = Twitter::REST::Client.new(twitter_config_mock)
      tweet = client.update("This is a Tweet!")
      expect(tweet).to eq("This is a Tweet!")
    end

    it "wall posts" do
      graph = instance_double(Koala::Facebook::API, {
        put_wall_post: "This is a Wall Post!"
        })

      wall_post = graph.put_wall_post("This is a Wall Post!")

      expect(wall_post).to eq("This is a Wall Post!")
    end
  end



end
