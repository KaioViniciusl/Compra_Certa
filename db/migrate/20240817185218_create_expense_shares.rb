class CreateExpenseShares < ActiveRecord::Migration[7.1]
  def change
    create_table :expense_shares do |t|
      t.float :share_amount
      t.string :category
      t.references :user, null: false, foreign_key: true
      t.references :expense, null: false, foreign_key: true

      t.timestamps
    end
  end
end
