class AddIndexToCompaniesEmail < ActiveRecord::Migration
  def change
    add_index :companies, :email, unique: true
  end
end
