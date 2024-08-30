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

  # Método para calcular o saldo total considerando todos os grupos
  def total_balance
    user_groups.sum do |user_group|
      (user_group.credit || 0) - (user_group.debit || 0)
    end
  end

  # Método para calcular o saldo de um usuário em um grupo específico
  def balance_for_group(group)
    user_group = user_groups.find_by(group: group)
    return 0 unless user_group

    user_group.credit - user_group.debit
  end

  # Método para obter o saldo de um usuário em cada grupo
  def group_balances
    user_groups.includes(:group).each_with_object({}) do |user_group, balances|
      balances[user_group.group] = user_group.credit - user_group.debit
    end
  end

  # Método para calcular o saldo em relação a uma despesa específica
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
