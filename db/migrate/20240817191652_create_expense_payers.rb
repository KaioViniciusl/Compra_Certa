class CreateExpensePayers < ActiveRecord::Migration[7.1]
  def change
    create_table :expense_payers do |t|
      t.float :paid_amount
      t.references :user, null: false, foreign_key: true
      t.references :group, null: false, foreign_key: true
      t.references :receiver, foreign_key: { to_table: "users" }

      t.timestamps
    end
  end
end
