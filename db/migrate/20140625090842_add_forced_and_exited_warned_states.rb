class AddForcedAndExitedWarnedStates < ActiveRecord::Migration
  def change
    add_column :sessions, :forced, :boolean, default: false
    add_column :sessions, :exited, :boolean, default: false
    add_column :sessions, :warned, :boolean, default: false
  end
end
