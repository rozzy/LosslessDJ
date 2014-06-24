class RenameUserIdColumn < ActiveRecord::Migration
  def change
    rename_column :secrets, :user_id, :users_id
  end
end
