class AddOffercountToJobPostings < ActiveRecord::Migration
  def change
    add_column :job_postings, :offercount, :integer, default: 0
  end
end
