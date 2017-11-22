class Story < ApplicationRecord
  mount_uploader :image, StoryImageUploader

  has_and_belongs_to_many :hashtags
end
