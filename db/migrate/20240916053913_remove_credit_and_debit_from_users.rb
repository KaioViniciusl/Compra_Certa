class RemoveCreditAndDebitFromUsers < ActiveRecord::Migration[6.1]
  def change
    # Remove a coluna credit se ela existir
    remove_column :users, :credit, :decimal, precision: 10, scale: 2, default: "0.0", null: false if column_exists?(:users, :credit)

    # Remove a coluna debit se ela existir
    remove_column :users, :debit, :decimal, precision: 10, scale: 2, default: "0.0", null: false if column_exists?(:users, :debit)
  end
end
