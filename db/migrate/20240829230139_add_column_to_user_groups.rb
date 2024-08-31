class AddColumnToUserGroups < ActiveRecord::Migration[7.1]
  def change
    add_column :user_groups, :credit, :float
  end
end
