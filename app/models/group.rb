class Group < ApplicationRecord
  belongs_to :user
  has_many :expenses
  has_many :expense_shares, through: :expenses
  has_many :expense_payers
  has_many :user_groups
  has_many :users, through: :user_groups
  has_many :user_groups, dependent: :destroy
  before_destroy :check_for_expenses

  has_one_attached :photo

  validates :name_group, presence: true
  validates :description_group, presence: true

  def add_user(user)
    user_groups.create_or_find_by(user:, user_mail: user.email, invite_accepted: true)
  end

  def generate_token
    self.last_token = SecureRandom.urlsafe_base64
    save
  end

  def calculate_balance_by_user(user)
    total_balance = calculate_owed_amounts_with_payments
    users_owed = []
    users_owing = total_balance[user]&.map { |k, v| { k => v } } || []
    credit = 0
    total_balance.each do |debtor, creditors|
      if creditors[user]
        credit += creditors[user]
        users_owed << { debtor => creditors[user] }
      end
    end
    debit = total_balance[user]&.values&.sum || 0
    { credit: credit, debit: debit, users_owed: users_owed, users_owing: users_owing }
  end

  def calculate_owed_amounts_with_payments
    total_amount = expense_shares.sum(&:share_amount)
    shares = expense_shares.includes(:user).each_with_object({}) do |share, hash|
      hash[share.user] = 0 unless hash[share.user]
      hash[share.user] += share.share_amount.to_f
    end

    total_users = shares.size
    return {} if total_users.zero?

    per_person_amount = total_amount.to_f / total_users
    debts = {}

    shares.each do |user, share_amount|
      owed_amount = per_person_amount - share_amount
      debts[user] = owed_amount.round(2) if owed_amount != 0
    end

    expense_payers.each do |payment|
      payer = payment.user
      receiver = payment.receiver
      amount_paid = payment.paid_amount

      if debts[payer] && debts[receiver]
        debts[payer] -= amount_paid
        debts[receiver] += amount_paid
      elsif debts[payer]
        debts[payer] -= amount_paid
      elsif debts[receiver]
        debts[receiver] += amount_paid
      end
    end

    positive_debts = debts.select { |_, amount| amount.negative? }
    negative_debts = debts.select { |_, amount| amount.positive? }

    result = {}

    negative_debts.each do |user_owing, amount_owing|
      result[user_owing] = {}

      positive_debts.each do |user_owed, amount_owed|
        break if amount_owing <= 0

        payment = [amount_owing, -amount_owed].min
        result[user_owing][user_owed] = payment

        debts[user_owed] += payment
        debts[user_owing] -= payment
      end
    end

    result
  end

  def users
    user_groups.map(&:user).compact
  end

  private

  def check_for_expenses
    if expenses.exists?
      errors.add(:base, "Não é possível excluir o grupo porque ele já tem despesas associadas.")
      throw :abort
    end
  end
end
