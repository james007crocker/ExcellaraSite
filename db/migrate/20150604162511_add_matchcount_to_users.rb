class AddMatchcountToUsers < ActiveRecord::Migration
  def change
    add_column :users, :matchcount, :integer, default: 0
  end
end
