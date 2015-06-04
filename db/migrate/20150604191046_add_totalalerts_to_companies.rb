class AddTotalalertsToCompanies < ActiveRecord::Migration
  def change
    add_column :companies, :totalalerts, :integer, default: 0
  end
end
