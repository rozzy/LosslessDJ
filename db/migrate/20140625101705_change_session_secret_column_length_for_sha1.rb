class ChangeSessionSecretColumnLengthForSha1 < ActiveRecord::Migration
  def change
    change_column :sessions, :secret_code, :string, length: 40, null: false
  end
end
