class ChangeDefaultShareAmountInExpenseShares < ActiveRecord::Migration[7.0]
  def change
    change_column_default :expense_shares, :share_amount, 0
  end
end
