class Expense < ApplicationRecord
  belongs_to :group
  has_many :expense_shares
  has_many :expense_payers

  validates :name_expense, :description, :date, :amount, presence: true
end
