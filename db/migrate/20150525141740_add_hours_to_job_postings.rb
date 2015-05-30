class AddHoursToJobPostings < ActiveRecord::Migration
  def change
    add_column :job_postings, :hours, :integer
  end
end
