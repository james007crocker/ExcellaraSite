class AddResetToCompanies < ActiveRecord::Migration
  def change
    add_column :companies, :reset_digest, :string
    add_column :companies, :reset_sent_at, :datetime
  end
end
