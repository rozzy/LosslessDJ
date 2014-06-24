class UserList < ActiveRecord::Migration
  def self.up
   create_table :user_list do |t|
    t.string "actual_login", limit: 64
    t.string "actual_email", limit: 64
  end
 end

 def self.down
   drop_table :user_list
 end
end
