class Story < ApplicationRecord
  mount_uploader :image, StoryImageUploader
  reverse_geocoded_by :latitude, :longitude

  has_and_belongs_to_many :hashtags
  belongs_to :user, optional: true
end
