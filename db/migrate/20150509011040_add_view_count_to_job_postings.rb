class AddViewCountToJobPostings < ActiveRecord::Migration
  def change
    add_column :job_postings, :views, :integer
  end
end
