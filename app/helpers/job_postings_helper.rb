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

  def increment_view_count(job)
    if job.views.nil?
      return 1
    else
      return job.views + 1
    end
  end
end

