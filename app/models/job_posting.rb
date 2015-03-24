class JobPosting < ActiveRecord::Base
  belongs_to :company
  default_scope -> { order(created_at: :desc) }
  validates :title, presence: true, length: { maximum: 20 }
  validates :location, presence: true, length: { maximum: 20 }
  validates :description, presence: true

end
