class AddForcedColumnToSecrets < ActiveRecord::Migration
  def change
    add_column :secrets, :forced, :boolean, default: false
  end
end
