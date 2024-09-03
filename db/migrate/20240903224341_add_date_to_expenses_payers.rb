class AddDateToExpensesPayers < ActiveRecord::Migration[7.1]
  def change
    add_column :expense_payers, :date_expense_payers, :date
  end
end
