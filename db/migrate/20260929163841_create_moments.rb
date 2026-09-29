class CreateMoments < ActiveRecord::Migration[8.1]
  def change
    create_table :moments do |t|
      t.references :user, null: false, foreign_key: true
      t.references :day, null: false, foreign_key: true
      t.text :caption
      t.string :reply
      t.string :reaction

      t.timestamps
    end
     add_index :moments, [:user_id, :day_id], unique: true
  end
end
