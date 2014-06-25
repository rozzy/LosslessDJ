class AddLastVisitToSession < ActiveRecord::Migration
  def change
    add_column :sessions, :last_visit, :datetime
  end
end
