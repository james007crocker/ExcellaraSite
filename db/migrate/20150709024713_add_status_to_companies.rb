class AddStatusToCompanies < ActiveRecord::Migration
  def change
    add_column :companies, :status, :integer, default: 0
  end
end
