class Group < ApplicationRecord
  has_one_attached :photo
  belongs_to :user

  validates :name_group, presence: true
  validates :observation, presence: true
end
