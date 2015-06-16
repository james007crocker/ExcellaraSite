class AddProfileurlToUsers < ActiveRecord::Migration
  def change
    add_column :users, :profileurl, :string, default: nil
  end
end
