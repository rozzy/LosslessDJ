class RenameWornedToExpiredSessionColumn < ActiveRecord::Migration
  def change
    rename_column :sessions, :warned, :expired
  end
end
