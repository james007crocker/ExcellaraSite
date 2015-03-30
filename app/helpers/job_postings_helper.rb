module JobPostingsHelper
  def getjob
    if !current_company.nil?
      @jobposting = current_company.job_postings.find_by(id: params[:id])
    else
      @jobposting = JobPosting.find_by(id: params[:id])
    end
  end

  def state(job_posting)
    applicant = job_posting.applicants.find_by(user_id: current_user.id)
    if applicant.nil?
      return "Apply"
    elsif applicant.userAccept && applicant.compAccept
      return "Match"
    else
      return "Pending"
    end
  end
end

