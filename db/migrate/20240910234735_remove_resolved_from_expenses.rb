class RemoveResolvedFromExpenses < ActiveRecord::Migration[7.1]
  def change
    remove_column :expenses, :resolved, :boolean
  end
end
