class User < ApplicationRecord
  mount_uploader :image, AvatarUploader

  has_many :stories
  has_many :services
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable, :omniauthable
end
