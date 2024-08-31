class Expense < ApplicationRecord
  belongs_to :group
  belongs_to :user
  has_many :expense_shares, dependent: :destroy

  validates :name_expense, :description, :date, :amount, presence: true

  def handle_expense_shares(expense_shares_params)
    ExpenseShare.where(expense: self).destroy_all

    return if expense_shares_params.nil? || !expense_shares_params.is_a?(Hash)

    expense_shares_params.each do |user_id, share_amount|
      ExpenseShare.create(expense: self, user_id: user_id, share_amount: share_amount.to_f)
    end
  end
end
