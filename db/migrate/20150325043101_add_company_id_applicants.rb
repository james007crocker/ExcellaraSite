class AddCompanyIdApplicants < ActiveRecord::Migration
  def change
    add_column :applicants, :company_id, :integer
  end
end
