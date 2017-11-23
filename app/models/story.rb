class Story < ApplicationRecord
  has_and_belongs_to_many :hashtags
  belongs_to :users
end
