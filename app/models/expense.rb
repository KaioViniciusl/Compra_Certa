class Expense < ApplicationRecord
  belongs_to :group
  belongs_to :user
  has_many :expense_shares
  has_many :expense_payers

  validates :name_expense, :description, :date, :amount, presence: true

  def calculate_debts
    total_amount = amount
    shares = expense_shares.includes(:user).map { |share| [share.user, share.share_amount] }.to_h

    total_users = shares.size
    per_person_amount = total_amount / total_users
    debts = {}

    shares.each do |user, share_amount|
      owed_amount = per_person_amount - share_amount
      debts[user] = owed_amount if owed_amount != 0
    end

    debts
  end

  def handle_expense_shares(expense_shares_params)
    ExpenseShare.where(expense: self).destroy_all

    return if expense_shares_params.nil? || !expense_shares_params.is_a?(Hash)

    expense_shares_params.each do |user_id, share_amount|
      ExpenseShare.create(expense: self, user_id: user_id, share_amount: share_amount.to_f)
    end
  end
end
