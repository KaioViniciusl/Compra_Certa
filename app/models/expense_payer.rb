class ExpensePayer < ApplicationRecord
  belongs_to :user
  belongs_to :group
  belongs_to :receiver, class_name: "User"

  validates :paid_amount, presence: true, numericality: { greater_than_or_equal_to: 0 }
  validates :date, presence: true
end
