class AddProvinceToCompanies < ActiveRecord::Migration
  def change
    add_column :companies, :province, :string
  end
end
