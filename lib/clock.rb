require File.expand_path('../../config/boot',        __FILE__)
require File.expand_path('../../config/environment', __FILE__)
require 'clockwork'

include Clockwork

handler do |job|
  puts "Running #{job}"
end

every(1.minute, 'House Keeping With Applications'){
  Applicant.all.each do |app|
    if app.compreject || app.userreject && app.updated_at < Date.today() - 7.days
      puts "Deleting Application: " + app.id.to_s + " Job: " + app.job_posting_id.to_s
      app.destroy
    elsif app.compAccept && app.userAccept && app.updated_at < Date.today() - 14.days
      puts "Requesting Status of Application: " + app.id.to_s
      #||||||||||---------|||||||||Send Mail to both comp and user
    elsif app.compAccept && !app.userAccept && app.updated_at < Date.today() - 7.days
      puts "Prompting Application Response of App: " + app.id.to_s + " from User: " + app.user_id.to_s
      #||||||||||---------|||||||||Send Mail to user requesting action
    elsif app.userAccept && !app.compAccept && app.updated_at < Date.today() - 7.days
      puts "Prompting Application Response of App: " + app.id.to_s + " from Company: " + app.company_id.to_s
      #||||||||||---------|||||||||Send Mail to company requesting action
    end
  end
}

#Add :at => time so that this occurs at night
# every( 7.minute, 'Initiating the MATCH'){
#   puts "Beginning the Match Automation Process"
#   User.each do |user|
#     if user.sector == "Accounting" || user.sector == "Human Resources" || user.sector == "Law"
#       suggestedJob = []
#       suggestedLink = []
#       jobs = JobPosting.where(:location => user.location, :sector => user.sector).where("created_at > ?", Date.now - 7.days).order('date ASC, created_at ASC')
#       unless jobs.nil?
#         jobs.each do |job|
#           unless Applicant.where(:job_posting_id => job.id, :user_id => user.id)
#             suggestedJob << job.title + " - " + job.company.name + " - " + job.location + " - " + job.length + " - " + job.hours + "/week"
#             suggestedLink << job_posting_url(job)
#           end
#           if suggestedJob.size == 3
#             break
#           end
#         end
#       end
#
#
#       #||||||||||---------|||||||||Send mail to whoever needs job
#     end
#   end
#
#   JobPosting.each do |job|
#     suggestedUser = []
#     suggestedLink = []
#     if job.sector == "Accounting" || job.sector == "Human Resources" || user.sector == "Law"
#       if job.created_at < Date.now - 7.days
#         users = User.where(:location => job.location, :sector => job.sector).where("created_at > ?", Date.now - 7.days)
#         users.each do |user|
#           unless Applicant.where(:job_posting_id => job.id, :user_id => user.id)
#             suggestedUser << user.name + " " + user.lastname
#             suggestedLink << user_url(user)
#           end
#           if suggestedUser.size == 5
#             break
#           end
#         end
#       else
#         users = User.where(:location => job.location, :sector => job.sector).order('date ASC, created_at ASC')
#         users.each do |user|
#           unless Applicant.where(:job_posting_id => job.id, :user_id => user.id)
#             suggestedUser << user.name + " " + user.lastname
#             suggestedLink << user_url(user)
#           end
#           if suggestedUser.size == 5
#             break
#           end
#         end
#       end
#
#       #||||||||||---------|||||||||Send mail to whoever needs job
#     end
#   end
# }
#
#
#
# #Add :at => time so that this occurs at night
# every(5.minute, 'House Keeping With Companies'){
#   Company.each do |comp|
#     if comp.admin == false && JobPosting.where(:company_id => comp.id).count == 0
#       #||||||||||---------|||||||||Send mail to whoever needs job
#     end
#   end
# }
