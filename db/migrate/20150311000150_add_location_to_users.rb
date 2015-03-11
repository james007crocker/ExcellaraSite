class AddLocationToUsers < ActiveRecord::Migration
  def change
    add_column :users, :location, :string
    add_column :users, :experience, :text
    add_column :users, :accomplishment, :text
  end
end
