class AddDefaultToAmountInExpenses < ActiveRecord::Migration[7.1]
  def change
    change_column_default :expenses, :amount, 0.00
  end
end
