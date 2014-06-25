class AddColumnToSecrets < ActiveRecord::Migration
  def change
    add_column :secrets, :confirmed, :boolean, default: false
  end
end
