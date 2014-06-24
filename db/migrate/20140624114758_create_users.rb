class CreateUsers < ActiveRecord::Migration
  def self.up
    create_table :users do |t|
      t.string :actual_login, limit: 64
      t.string :actual_email, limit: 64
    end
  end

  def self.down
   drop_table :users
  end
end
