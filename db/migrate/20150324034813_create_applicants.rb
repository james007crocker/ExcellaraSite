class CreateApplicants < ActiveRecord::Migration
  def change
    create_table :applicants do |t|
      t.boolean :compAccept
      t.boolean :userAccept
      t.references :job_posting, index: true
      t.integer :user_id

      t.timestamps null: false
    end
    add_foreign_key :applicants, :job_postings
    add_index :applicants, [:job_posting_id, :created_at]
  end
end
