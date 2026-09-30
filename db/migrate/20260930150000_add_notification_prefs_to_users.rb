class AddNotificationPrefsToUsers < ActiveRecord::Migration[8.1]
  def change
    add_column :users, :notify_uploads, :boolean, default: true, null: false
    add_column :users, :notify_reveals, :boolean, default: true, null: false
    add_column :users, :notify_reminder, :boolean, default: true, null: false
  end
end
