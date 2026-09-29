class AddMeetToUsers < ActiveRecord::Migration[8.1]
  def change
    add_column :users, :meet_on, :date       # próxima vez que se ven
    add_column :users, :meet_set_on, :date   # cuándo se puso la fecha (para la barra de progreso)
  end
end
