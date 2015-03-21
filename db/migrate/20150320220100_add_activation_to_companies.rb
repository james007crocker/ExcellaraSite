class AddActivationToCompanies < ActiveRecord::Migration
  def change
    add_column :companies, :activation_digest, :string
    add_column :companies, :activated, :boolean
    add_column :companies, :activated_at, :datetime
  end
end
