class AddAdminToCompanies < ActiveRecord::Migration
  def change
    add_column :companies, :admin, :boolean, default: false
  end
end
