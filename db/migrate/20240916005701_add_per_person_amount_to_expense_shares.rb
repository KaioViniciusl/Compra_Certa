class AddPerPersonAmountToExpenseShares < ActiveRecord::Migration[7.1]
  def change
    add_column :expense_shares, :per_person_amount, :decimal, precision: 10, scale: 2
  end
end
