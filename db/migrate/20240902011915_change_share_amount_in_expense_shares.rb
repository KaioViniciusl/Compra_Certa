class ChangeShareAmountInExpenseShares < ActiveRecord::Migration[7.1]
  def change
    change_column :expense_shares, :share_amount, :decimal, default: 0.00, precision: 10, scale: 2
  end
end
