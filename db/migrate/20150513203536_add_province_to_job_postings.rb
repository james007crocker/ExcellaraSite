class AddProvinceToJobPostings < ActiveRecord::Migration
  def change
    add_column :job_postings, :province, :string
  end
end
