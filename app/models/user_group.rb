class UserGroup < ApplicationRecord
  belongs_to :user, optional: true
  belongs_to :group

  validates :invite_accepted, inclusion: { in: [true, false] }
end
