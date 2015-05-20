class AddUserrejectToApplicants < ActiveRecord::Migration
  def change
    add_column :applicants, :userreject, :boolean, default: false
  end
end
