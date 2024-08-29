class ExpenseShare < ApplicationRecord
  belongs_to :user
  belongs_to :expense

  validates :share_amount, numericality: { greater_than_or_equal_to: 0 }
end
