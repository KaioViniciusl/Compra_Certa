class UserGroup < ApplicationRecord
  belongs_to :user, optional: true
  belongs_to :group

  validates :invite_accepted, inclusion: { in: [true, false] }

  def update_credit_and_debit
    total_amount = group.expenses.sum(:amount)
    total_users = group.users.count
    per_person_amount = total_amount / total_users.to_f

    total_paid = user.expense_shares.where(expense: group.expenses).sum(:share_amount)
    total_due = per_person_amount * group.expenses.count

    self.debit = [total_due - total_paid, 0].max
    self.credit = [total_paid - total_due, 0].max
    save!
  end
end
