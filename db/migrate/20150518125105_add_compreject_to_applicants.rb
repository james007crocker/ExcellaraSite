class AddComprejectToApplicants < ActiveRecord::Migration
  def change
    add_column :applicants, :compreject, :boolean, default: false
  end
end
