class AddUserrejectToJobPostings < ActiveRecord::Migration
  def change
    add_column :job_postings, :userreject, :boolean,  default: false
  end
end
