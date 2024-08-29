class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
  has_many :expenses, through: :expense_shares
  has_many :expense_shares
  has_many :expense_payers
  has_many :groups
  has_many :user_groups
  has_many :payments, class_name: "ExpensePayer", foreign_key: "receiver_id"
  has_one_attached :photo
  after_create_commit :accept_invitations

  def total_balance
    groups = Group.joins(:expenses => :expense_shares).where(expense_shares: { user_id: self.id }).distinct

    total_balance = 0

    groups.each do |group|
      total_balance += balance_for_group(group)
    end

    total_balance
  end

  def balance_for_group(group)
    expenses = group.expenses.joins(:expense_shares).where(expense_shares: { user_id: self.id })

    total_due = 0
    total_paid = 0

    expenses.each do |expense|
      total_shares = expense.expense_shares.count
      per_user_amount = expense.amount / total_shares.to_f

      total_due += per_user_amount
      total_paid += expense.expense_shares.find_by(user_id: self.id).try(:share_amount).to_f
    end

    total_paid - total_due
  end

  def balance_for_expense(expense_id)
    expense = Expense.find_by(id: expense_id)
    return "Despesa não encontrada" if expense.nil?

    total_amount = expense.amount

    total_shares = expense.expense_shares.count

    per_user_amount = total_amount / total_shares.to_f

    user_share = expense.expense_shares.find_by(user_id: self.id)
    total_paid = user_share.try(:share_amount).to_f

    total_paid - per_user_amount
  end

  def accept_invitations
    invitations = UserGroup.where(user_mail: email, invite_accepted: false)
    invitations.update_all(user_id: id, invite_accepted: true)
  end
end
