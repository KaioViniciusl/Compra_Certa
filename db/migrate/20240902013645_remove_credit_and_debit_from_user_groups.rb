class RemoveCreditAndDebitFromUserGroups < ActiveRecord::Migration[7.1]
  def change
    remove_column :user_groups, :credit, :float
    remove_column :user_groups, :debit, :float
  end
end
