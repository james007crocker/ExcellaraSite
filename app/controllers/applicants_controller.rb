class ApplicantsController < ApplicationController
  def create
    if current_company
    elsif current_user
      jobposting = JobPosting.find_by(id: params[:job_id])
      applicant = jobposting.applicants.build
      applicant.userAccept = true
      applicant.compAccept = false
      applicant.user_id = current_user.id
      applicant.company_id = jobposting.company.id
      if applicant.save
        flash[:success] = "Successfully applied for job"
        redirect_to joblist_path
      else
        flash[:danger] = "Error applying for job"
        redirect_to current_user
      end
    end
  end

  def destroy
    @applicant.destroy
    redirect_to request.referrer || root_url
  end
end
