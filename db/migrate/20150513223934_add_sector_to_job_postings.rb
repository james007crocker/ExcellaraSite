class AddSectorToJobPostings < ActiveRecord::Migration
  def change
    add_column :job_postings, :sector, :string
  end
end
