class CreatePromptPairs < ActiveRecord::Migration[8.1]
  def change
    create_table :prompt_pairs do |t|
      t.string :prompt_a
      t.string :prompt_b
      t.string :conversation_question

      t.timestamps
    end
  end
end
