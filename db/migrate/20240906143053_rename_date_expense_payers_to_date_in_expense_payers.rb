class RenameDateExpensePayersToDateInExpensePayers < ActiveRecord::Migration[7.1]
  def change
    rename_column :expense_payers, :date_expense_payers, :date
  end
end
