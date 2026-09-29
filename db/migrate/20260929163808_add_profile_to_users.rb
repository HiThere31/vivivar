class AddProfileToUsers < ActiveRecord::Migration[8.1]
  def change
    add_column :users, :name, :string
    add_column :users, :theme, :string
    add_column :users, :partner_id, :integer

    add_index :users, :partner_id
    add_foreign_key :users, :users, column: :partner_id
  end
end
