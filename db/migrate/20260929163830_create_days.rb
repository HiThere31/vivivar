class CreateDays < ActiveRecord::Migration[8.1]
  def change
    create_table :days do |t|
      t.date :date
      t.datetime :revealed_at
      t.references :prompt_pair, null: false, foreign_key: true

      t.timestamps
    end
    add_index :days, :date, unique: true
  end
end
