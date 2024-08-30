class AddColumnDebitToUserGroups < ActiveRecord::Migration[7.1]
  def change
    add_column :user_groups, :debit, :float
  end
end
