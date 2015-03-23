class CreateJobPostings < ActiveRecord::Migration
  def change
    create_table :job_postings do |t|
      t.string :title
      t.string :location
      t.text :description
      t.references :company, index: true

      t.timestamps null: false
    end
    add_foreign_key :job_postings, :companies
    add_index :job_postings, [:company_id, :created_at]
  end
end
