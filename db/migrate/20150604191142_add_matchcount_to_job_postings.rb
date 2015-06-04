class AddMatchcountToJobPostings < ActiveRecord::Migration
  def change
    add_column :job_postings, :matchcount, :integer, default: 0
  end
end
