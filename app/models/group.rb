class Group < ApplicationRecord
  belongs_to :user
  has_many :user_groups

  has_one_attached :photo

  validates :name_group, presence: true
  validates :observation, presence: true

  def users
    user_groups.map(&:user).compact
  end
end
