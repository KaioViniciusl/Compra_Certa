module GroupsHelper
  def determine_user_status(expense)
    share = expense.expense_shares.find_by(user: current_user)
    return 'not_involved' unless share

    user_share_amount = share.share_amount
    total_amount = expense.amount
    total_shares = expense.expense_shares.sum(:share_amount)
    per_user_amount = total_amount / total_shares

    balance = user_share_amount - per_user_amount

    if balance < 0
      'debt'
    elsif balance > 0
      'credit'
    else
      'not_involved'
    end
  end
end
