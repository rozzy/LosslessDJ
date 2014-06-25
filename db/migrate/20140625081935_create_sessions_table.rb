class CreateSessionsTable < ActiveRecord::Migration
  def self.up
    create_table :sessions do |t|
      t.integer :user_id
      t.string :secret_code, limit: 32
      t.string :session_ip, limit: 20
      t.timestamp :expires

      t.timestamps
    end
  end

  def self.down
   drop_table :sessions
  end
end
