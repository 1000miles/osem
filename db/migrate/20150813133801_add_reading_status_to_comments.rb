class AddReadingStatusToComments < ActiveRecord::Migration
  def change
    add_column :comments, :unread, :boolean, default: false
  end
end
