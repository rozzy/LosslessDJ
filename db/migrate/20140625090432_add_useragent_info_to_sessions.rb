class AddUseragentInfoToSessions < ActiveRecord::Migration
  def change
    add_column :sessions, :useragent, :string, length: 250, null: false
  end
end
