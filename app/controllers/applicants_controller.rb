class ApplicantsController < ApplicationController
  def create
    if current_company
      jobposting = JobPosting.find_by(id: params[:job_id])
      applicant = jobposting.applicants.build
      applicant.userAccept = false
      applicant.compAccept = true
      user = User.find_by(id: params[:user_id])
      applicant.user_id = user.id
      applicant.company_id = current_company.id
      if applicant.save
        flash[:success] = "A message has been sent to" + user.name
        redirect_to users_path
      else
        flash[:danger] = "Error recruiting professional"
        redirect_to current_company
      end
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

  def update
    if current_user
      @applicant = Applicant.find_by(id: params[:id])
      @job = @applicant.job_posting
      @applicant.update_attribute(:userAccept, true)
      @receiver = Company.find_by(id: @applicant.company_id)
    elsif current_company
      @applicant = Applicant.find_by(id: params[:id])
      @job = @applicant.job_posting
      @applicant.update_attribute(:compAccept, true)
      @receiver = User.find_by(id: @applicant.user_id)
    end
  end


  def send_match_email
    if current_user
      @sender = current_user
      @receiver = Company.find_by(id: params[:receiver])
    else
      @sender = current_company
      @receiver = User.find_by(id: params[:receiver])
    end
    @text = params[:text]
    @job = JobPosting.find_by(id: params[:job])
    ####################################################-------------------------Add action mailer thing here!!!
  end

  def destroy
    @applicant.destroy
    redirect_to request.referrer || root_url
  end
end
