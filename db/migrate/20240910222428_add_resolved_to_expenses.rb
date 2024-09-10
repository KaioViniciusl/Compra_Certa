class AddResolvedToExpenses < ActiveRecord::Migration[7.1]
  def change
    add_column :expenses, :resolved, :boolean, default: false
  end
end
