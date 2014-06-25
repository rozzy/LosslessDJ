class AddSecretKeyColumnToSessions < ActiveRecord::Migration
  def change
    add_column :sessions, :secret_key, :string
  end
end
