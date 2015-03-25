class Applicant < ActiveRecord::Base
  belongs_to :job_posting
  default_scope -> { order(created_at: :desc)}
end
