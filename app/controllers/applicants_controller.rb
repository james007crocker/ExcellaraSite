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
        flash[:success] = "A message has been sent to " + user.name
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
    else
      flash[:danger] = "You do not have permission to view this page"
      redirect_to root_path
    end
  end

  def destroy
    applicant = Applicant.find_by(id: params[:id])
    if !current_company.nil? && (current_company.id == applicant.company_id) || !current_user.nil? && (current_user.id === applicant.user_id)
      applicant.destroy
      flash[:success] = "Application Removed"
      if current_company
        redirect_to current_company
      else
        redirect_to current_user
      end
    else
      redirect_to root_url
    end

  end

  def update
    if current_user
      @text = nil
      @sender = current_user
      application = Applicant.find_by(id: params[:id])
      application.update_attribute(:userAccept, true)
      @job = application.job_posting
      @receiver = Company.find_by(id: application.company_id)
      @sendresume = params[:sendresume]
      UserMailer.match_email(@sender, @receiver, @job, @text, @sendresume).deliver_now
      UserMailer.match_email2(@receiver, @sender, @job, @text).deliver_now
      flash[:success] = "Email sent to " + @receiver.name + " about " + @job.title + " match"
      redirect_to matched_jobs_users_path
    elsif current_company
      @text = nil
      @sender = current_company
      application = Applicant.find_by(id: params[:id])
      application.update_attribute(:compAccept, true)
      @job = application.job_posting
      @receiver = User.find_by(id: application.user_id)
      @sendresume = params[:sendresume]
      UserMailer.match_email2(@sender, @receiver, @job, @text).deliver_now
      UserMailer.match_email(@receiver, @sender, @job, @text, @sendresume).deliver_now
      flash[:success] = "Email sent to " + @receiver.name + " about " + @job.title + " match"
      redirect_to activity_companies_path
    else
      flash[:danger] = "You do not have permission to view this page"
      redirect_to root_path
    end
  end


  def send_match_email
  #This was originally used to send an email during a match situation - it has since been updated and is now unused
    @applicant = Applicant.find_by(id: params[:app_id])
    if current_user
      @applicant.update_attribute(:userAccept, true)
      @sender = current_user
      @receiver = Company.find_by(id: params[:receiver])
      @sendresume = params[:sendresume]
    elsif current_company
      @applicant.update_attribute(:compAccept, true)
      @sender = current_company
      @receiver = User.find_by(id: params[:receiver])
    else
      flash[:danger] = "You do not have permission to view this page"
      redirect_to root_path
    end
    @text = params[:text]
    @job = JobPosting.find_by(id: params[:job])
    #UserMailer.match_email(@sender, @receiver, @job, @text, @sendresume).deliver_now
    flash[:success] = "Contacted " + @receiver.name + " about " + @job.title + " match"
    if current_user
      redirect_to current_user
    else
      redirect_to current_company
    end
  end

  def destroy
    Applicant.find_by(id: params[:id]).destroy
    flash[:success] = "Application successfully removed"
    if current_user
      redirect_to matched_jobs_users_path
    elsif current_company
      redirect_to activity_companies_path
    else
      redirect_to request.referrer || root_url
    end
  end
end
