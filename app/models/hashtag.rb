class Hashtag < ApplicationRecord
  has_and_belongs_to_many :stories
  validates :name , uniqueness: true
  validates :name , presence: true
end
