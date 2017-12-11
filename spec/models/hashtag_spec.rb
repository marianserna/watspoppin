require 'rails_helper'

RSpec.describe Hashtag, type: :model do

  describe 'create hashtag' do
    it 'create instance of hashtag model and make sure it saves' do
      hashtag = Hashtag.new
      hashtag.name = "hashtagTest"
      hashtag.save
      expect(hashtag.persisted?).to eql(true)
    end
  end

  describe 'associations' do
    it "should have many stories" do
      story = Hashtag.reflect_on_association(:stories)
      expect(story.macro).to eq(:has_and_belongs_to_many)
    end
  end

  describe 'validations' do
    it 'Duplicate hashtag name should throw an error' do
      firstTag = Hashtag.create(name: "testing12345")
      secondTag = Hashtag.create(name: "testing12345")
      expect(secondTag.errors[:name]).to eql(['has already been taken'])
    end
    it "Empty hashtag should throw an error" do
      tag = Hashtag.create(name: "")
      expect(tag.errors[:name]).to eql(["can't be blank"])
    end
  end

end
