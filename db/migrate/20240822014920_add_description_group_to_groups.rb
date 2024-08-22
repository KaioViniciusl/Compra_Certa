class AddDescriptionGroupToGroups < ActiveRecord::Migration[7.1]
  def change
    add_column :groups, :description_group, :string, default: ""
  end
end
