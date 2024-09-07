class AddLastTokenToGroups < ActiveRecord::Migration[7.1]
  def change
    add_column :groups, :last_token, :string
  end
end
