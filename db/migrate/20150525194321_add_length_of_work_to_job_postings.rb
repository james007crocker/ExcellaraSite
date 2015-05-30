class AddLengthOfWorkToJobPostings < ActiveRecord::Migration
  def change
    add_column :job_postings, :length, :string
  end
end
