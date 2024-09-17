class RemoveCreditAndDebitFromUsers < ActiveRecord::Migration[6.1]
  def change
    remove_column :users, :credit, :decimal, precision: 10, scale: 2, default: "0.0", null: false
    remove_column :users, :debit, :decimal, precision: 10, scale: 2, default: "0.0", null: false
  end
end
