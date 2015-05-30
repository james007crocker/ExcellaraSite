class AddYearsToUsers < ActiveRecord::Migration
  def change
    add_column :users, :years, :integer
  end
end
