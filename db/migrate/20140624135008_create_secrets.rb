class CreateSecrets < ActiveRecord::Migration
  def self.up
    create_table :secrets do |t|
      t.integer :user_id
      t.string :secret_code, limit: 32
      t.timestamp :expires

      t.timestamps
    end
  end

  def self.down
   drop_table :secrets
  end
end
