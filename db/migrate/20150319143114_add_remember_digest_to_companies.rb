class AddRememberDigestToCompanies < ActiveRecord::Migration
  def change
    add_column :companies, :remember_digest, :string
  end
end
