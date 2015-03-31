class JobPosting < ActiveRecord::Base
  belongs_to :company
  has_many :applicants, dependent: :destroy
  default_scope -> { order(created_at: :desc) }
  validates :title, presence: true, length: { maximum: 30 }
  validates :location, presence: true, length: { maximum: 20 }
  validates :description, presence: true

end
