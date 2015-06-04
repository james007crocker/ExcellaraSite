class AddOffercountToUsers < ActiveRecord::Migration
  def change
    add_column :users, :offercount, :integer, default: 0
  end
end
