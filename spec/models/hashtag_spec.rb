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
end
