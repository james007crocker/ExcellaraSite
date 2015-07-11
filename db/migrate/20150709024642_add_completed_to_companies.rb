class AddCompletedToCompanies < ActiveRecord::Migration
  def change
    add_column :companies, :completed, :boolean, default: false
  end
end
