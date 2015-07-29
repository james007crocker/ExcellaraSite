require File.expand_path('../../config/boot',        __FILE__)
require File.expand_path('../../config/environment', __FILE__)
require 'clockwork'

include Clockwork

handler do |job|
  puts "Running #{job}"
end

#Add :at => time so that this occurs at night
#Add :at => time so that this occurs at night
# every(5.minute, 'House Keeping With Applications'){
#   Applicant.all.each do |app|
#     if app.compreject || app.userreject && app.updated_at < Date.today() - 7.days
#       puts "A: Deleting Application: " + app.id.to_s + " Job: " + app.job_posting_id.to_s
#       app.destroy
#     elsif app.compAccept && app.userAccept && app.updated_at < Date.today() - 14.days
#       puts "A: Requesting Status of Application: " + app.id.to_s
#       user = User.find_by(id:  app.user_id)
#       comp = Company.find_by(id: app.company_id)
#       UserMailer.housekeepapplicationsBoth(user.email, app.job_posting.title, user.name, comp.name).deliver_now
#       UserMailer.housekeepapplicationsBoth(comp.email, app.job_posting.title, comp.name, user.name + " " + user.lastname).deliver_now
#     elsif app.compAccept && !app.userAccept && app.updated_at < Date.today() - 7.days
#       puts "A: Prompting Application Response of App: " + app.id.to_s + " from User: " + app.user_id.to_s
#       user = User.find_by(id:  app.user_id)
#       comp = Company.find_by(id: app.company_id)
#       UserMailer.housekeepapplicationsuser(user.email, app.job_posting.title, user.name, comp.name).deliver_now
#     elsif app.userAccept && !app.compAccept && app.updated_at < Date.today() - 7.days
#       puts "A: Prompting Application Response of App: " + app.id.to_s + " from Company: " + app.company_id.to_s
#       user = User.find_by(id:  app.user_id)
#       comp = Company.find_by(id: app.company_id)
#       UserMailer.housekeepapplicationscomp(comp.email, app.job_posting.title, user.name, comp).deliver_now
#     end
#   end
# }

#Add :at => time so that this occurs at night
 every( 5.minute, 'Initiating the MATCH'){
   #require 'active_support/inflector'
#   puts "Beginning the Match Automation Process"
#   User.where(:status => 2).each do |user|
#     if user.sector == "Accounting" || user.sector == "Human Resources" || user.sector == "Law"
#       suggestedJob = []
#       suggestedLink = []
#       jobs = JobPosting.where(:location => user.location, :sector => user.sector).where("updated_at > ?", Date.today() - 7.days).order('created_at ASC')
#       unless jobs.nil?
#         jobs.each do |job|
#           unless Applicant.where(:job_posting_id => job.id, :user_id => user.id).count > 0
#             suggestedJob << job.title + " - " + job.company.name + " - " + job.location + " - " + job.length + " - " + job.hours.to_s + "/week"
#             suggestedLink << Rails.application.routes.url_helpers.job_posting_url(job).to_s
#           end
#           if suggestedJob.size == 3
#             break
#           end
#         end
#       end
#       puts user.name + user.lastname
#       puts "------------------------"
#       suggestedJob.each do |f|
#         puts f
#       end
#       puts "////////////////////////"
#       puts " "
#
#       if suggestedJob.size > 0
#         UserMailer.jobssuggestedtousers(user.email, user.name, suggestedJob, suggestedLink).deliver_now
#       end
#     end
#   end

  JobPosting.all.each do |job|
    suggestedUser = []
    suggestedLink = []
    if job.sector == "Accounting" || job.sector == "Human Resources" || job.sector == "Law"
      if job.created_at < Date.today() - 7.days
        puts job.title + "A------------------A"
        users = User.where(:location => job.location, :sector => job.sector, :status => 2).where("created_at > ?", Date.today() - 7.days)
        users.each do |user|
          puts user.name + " " + user.lastname
          unless Applicant.where(:job_posting_id => job.id, :user_id => user.id).count > 0
            suggestedUser << user.name + " " + user.lastname + " - " + user.profession + " - " + user.years.to_s + " Years of  Experience"
            suggestedLink << Rails.application.routes.url_helpers.user_url(user)
          end
          if suggestedUser.size == 5
            break
          end
        end
      else
        puts job.title + "B------------------B"
        users = User.where(:location => job.location, :sector => job.sector, :status => 2).order('created_at ASC')
        users.each do |user|
          puts user.name + " " + user.lastname
          unless Applicant.where(:job_posting_id => job.id, :user_id => user.id).count > 0
            suggestedUser << user.name + " " + user.lastname + " - " + user.profession + " - " + user.years.to_s + " Years of  Experience"
            suggestedLink << Rails.application.routes.url_helpers.user_url(user)
          end
          if suggestedUser.size == 5
            break
          end
        end
      end
      puts job.company.name
      puts "----------------"
      suggestedUser.each do |f|
        puts f
      end
      puts "//////////////////"
      puts " "

      if suggestedUser.size > 0
        UserMailer.jobssuggestedtocompanies(job.company.email, job.title,  job.company.name, suggestedUser, suggestedLink).deliver_now
      end

    end
  end
}




#Add :at => time so that this occurs at night
# every(5.minute, 'House Keeping With Companies'){
#   Company.all.each do |comp|
#     if comp.admin == false && comp.status == 2 && JobPosting.where(:company_id => comp.id).count == 0
#       puts "C: Prompting Company to Post Jobs, Id: " + comp.id.to_s
#       UserMailer.postjobs(comp.email, comp.name).deliver_now
#     end
#   end
# }
