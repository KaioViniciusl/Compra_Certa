class CreateUserGroups < ActiveRecord::Migration[7.1]
  def change
    create_table :user_groups do |t|
      t.boolean :invite_accepted, default: false
      t.references :user, null: true, foreign_key: true
      t.references :group, null: false, foreign_key: true
      t.string :user_mail
      t.timestamps
    end
  end
end
