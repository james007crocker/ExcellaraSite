class AddCompanyrejectToJobPostings < ActiveRecord::Migration
  def change
    add_column :job_postings, :companyreject, :boolean
  end
end
