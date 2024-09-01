class AddDescriptionToExpensePayers < ActiveRecord::Migration[7.1]
  def change
    add_column :expense_payers, :description, :string
  end
end
