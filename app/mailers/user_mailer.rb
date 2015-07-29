class UserMailer < ApplicationMailer
  default from: 'admin@excellara.com'
  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.user_mailer.account_activation.subject
  #

  def mandrill_client
    require 'mandrill'
    @mandrill_client ||= Mandrill::API.new ENV['MANDRILL_PASSWORD']
  end

  def account_activation(receiver)
    template_name = 'activationemail'
    template_content = []
    message = {
        to: [{email: receiver.email}],
        subject: 'Excellara Account Activation',
        merge_vars: [
            {
                rcpt: receiver.email,
                vars: [
                    {
                        name: 'PRO_NAME', content: receiver.name,
                    },
                    {
                        name:  'ACCOUNT_LINK', content:  edit_account_activation_url(receiver.activation_token, email: receiver.email)
                    }
                ]
            }
        ]
    }

    mandrill_client.messages.send_template template_name, template_content, message

    #@receiver = receiver
    #mail to: receiver.email, subject: "Excellara Account Activation"
  end

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.user_mailer.password_reset.subject
  #
  def password_reset(receiver)
    template_name = 'passwordreset'
    template_content = []
    message = {
        to: [{email: receiver.email}],
        subject: 'Excellara Password Reset',
        merge_vars: [
            {
                rcpt: receiver.email,
                vars: [
                    {
                        name: 'PRO_NAME', content: receiver.name,
                    },
                    {
                        name:  'RESET_LINK', content:  edit_password_reset_url(receiver.reset_token, email: receiver.email)
                    }
                ]
            }
        ]
    }

    mandrill_client.messages.send_template template_name, template_content, message

    #@receiver = receiver
    #mail to: receiver.email, subject: "Excellara Password Reset"
  end

  def match_email(sender, receiver, job, text, sendresume)
    resumeflag = sender.resume.blank? || sender.resume.nil? ? 0 : 1
    template_name = 'matchemailtocompany'
    template_content = []
    message = {
        to: [{email: receiver.email}],
        subject: "Excellara Match: #{job.title} at #{sender.name}",
        merge_vars: [
            {
                rcpt: receiver.email,
                vars: [
                    {
                        name: 'PRO_NAME', content: sender.name,
                    },
                    {
                        name: 'PRO_EMAIL', content: sender.email
                    },
                    {
                        name: 'PRO_LINK', content: user_url(sender)
                    },
                    {
                        name:  'JOB_TITLE', content:  job.title
                    },
                    {
                        name:  'JOB_LINK', content:  job_posting_url(job)
                    },
                    {
                        name: 'RESUME_FLAG', content: resumeflag
                    },
                    {
                        name: 'RESUME_LINK', content: resume_users_url(id: sender.id)
                    }
                ]
            }
        ]
    }

    mandrill_client.messages.send_template template_name, template_content, message

    #@receiver = receiver
    #@sender = sender
    #@job = job
    #@text = text
    #@sendresume = sendresume
    #if Rails.env.production?
      #@link = "https://excellara-test.herokuapp.com/resume?id=" + @sender.id.to_s
    #else
      #@link = "http://localhost:3000/resume?id=" + @sender.id.to_s
    #end
    #if @receiver.kind_of? User
    #  subject_string = "Excellara Match: " + @job.title + " at " + @sender.name
    #  mail to: @receiver.email, subject: subject_string
    #else
    #  subject_string = "Excellara Match: " + @sender.name + " for " + @job.title
    #  mail to: @receiver.email, subject: subject_string
    #end
  end

  def match_email2(sender, receiver, job, text)

    template_name = 'matchemailtouser'
    template_content = []
    message = {
        to: [{email: receiver.email}],
        subject: "Excellara Match: #{job.title} at #{sender.name}",
        merge_vars: [
            {
                rcpt: receiver.email,
                vars: [
                    {
                        name: 'COMP_NAME', content: sender.name,
                    },
                    {
                        name: 'COMP_EMAIL', content: sender.email
                    },
                    {
                        name: 'COMP_LINK', content: company_url(sender)
                    },
                    {
                        name:  'JOB_TITLE', content:  job.title
                    },
                    {
                        name:  'JOB_LINK', content:  job_posting_url(job)
                    }
                ]
            }
        ]
    }

    mandrill_client.messages.send_template template_name, template_content, message

    #@receiver = receiver
    #@sender = sender
    #@job = job
    #@text = text
    #if @receiver.kind_of? User
    #  subject_string = "Excellara Match: " + @job.title + " at " + @sender.name
    #  mail to: @receiver.email, subject: subject_string
    #else
    #  subject_string = "Excellara Match: " + @sender.name + " for " + @job.title
    #  mail to: @receiver.email, subject: subject_string
    #end
  end

  def message_email(name, email, message)
    template_name = 'contactus'
    template_content = []
    message = {
        to: [{email: 'lauren@excellara.com'}],
        subject: 'Contact Us Message',
        merge_vars: [
            {
                rcpt: 'lauren@excellara.com',
                vars: [
                    {
                        name: 'PRO_NAME', content: name
                    },
                    {
                        name:  'MESSAGE', content:  message
                    },
                    {
                        name:  'EMAIL', content:  email
                    }
                ]
            }
        ]
    }

    mandrill_client.messages.send_template template_name, template_content, message

    #@name = name;
    #@email = email;
    #@message = message;
    #mail to: "lauren@excellara.com", subject: "Excellara - Contact Page Message"
  end

  def compsuggest(sender, receiver, job)
    template_name = 'companysuggested'
    template_content = []
    message = {
        to: [{email: receiver.email}],
        subject: "Excellara Job Interest: #{job.title}",
        merge_vars: [
            {
                rcpt: receiver.email,
                vars: [
                    {
                        name: 'COMP_NAME', content: sender.name
                    },
                    {
                        name: 'COMP_LINK', content:  company_url(sender)
                    },
                    {
                        name: 'JOB_TITLE', content: job.title
                    },
                    {
                        name: 'JOB_LINK', content: job_posting_url(job)
                    },
                    {
                        name: 'NEXT_STEP', content: matched_jobs_users_url
                    }
                ]
            }
        ]
    }

    mandrill_client.messages.send_template template_name, template_content, message

    #@receiver = receiver
    #@sender = sender
    #@job = job
    #mail to: @receiver.email, subject: "Excellara Job Interest: #{@job.title}"
  end

  def usersuggest(sender, receiver, job)
    resumeflag = sender.resume.blank? || sender.resume.nil? ? 0 : 1
    template_name = 'userapplied'
    template_content = []
    message = {
        to: [{email: receiver.email}],
        subject: "Excellara Job Interest: #{job.title}",
        merge_vars: [
            {
                rcpt: receiver.email,
                vars: [
                    {
                        name: 'PRO_NAME', content: sender.name + " " + sender.lastname
                    },
                    {
                        name:  'PRO_LINK', content:  user_url(sender)
                    },
                    {
                        name: 'RESUME_FLAG', content: resumeflag
                    },
                    {
                        name:  'PRO_RESUME', content:  resume_users_url(id: sender.id)
                    },
                    {
                        name: 'JOB_TITLE', content: job.title
                    },
                    {
                        name: 'JOB_LINK', content: job_posting_url(job)
                    },
                    {
                        name: 'NEXT_STEP', content: activity_companies_url(receiver)
                    }
                ]
            }
        ]
    }

    mandrill_client.messages.send_template template_name, template_content, message

    #@receiver = receiver
    #@sender = sender
    #@job = job
    #mail to: @receiver.email, subject: "Excellara Job Interest: #{@job.title}"
  end

  def housekeepcompanies(name, email)
    template_name = 'housekeepcompanies'
    template_content = []
    message = {
        to: [{email: email}],
        subject: "Excellara - Account Is Ready, Start Posting Jobs!",
        merge_vars: [
            {
                rcpt: email,
                vars: [
                    {
                        name: 'COMP_NAME', content: name
                    }
                ]
            }
        ]
    }

    mandrill_client.messages.send_template template_name, template_content, message
  end

  def housekeepapplicationsBoth(email, job, name1, name2)
    template_name = 'housekeepapplicationsboth'
    template_content = []
    message = {
        to: [{email: email}],
        subject: "Excellara - What's going on with the #{job} position?",
        merge_vars: [
            {
                rcpt: email,
                vars: [
                    {
                        name: 'JOB', content: job
                    },
                    {
                        name: 'NAME1', content: name1
                    },
                    {
                        name: 'NAME2', content: name2
                    }
                ]
            }
        ]
    }
    mandrill_client.messages.send_template template_name, template_content, message
  end

  def housekeepapplicationsBoth(email, job, name1, name2)
    template_name = 'housekeepapplicationsboth'
    template_content = []
    message = {
        to: [{email: email}],
        subject: "Excellara - What's going on with the #{job} position?",
        merge_vars: [
            {
                rcpt: email,
                vars: [
                    {
                        name: 'JOB', content: job
                    },
                    {
                        name: 'NAME1', content: name1
                    },
                    {
                        name: 'NAME2', content: name2
                    }
                ]
            }
        ]
    }
    mandrill_client.messages.send_template template_name, template_content, message
  end

  def housekeepapplicationsuser(email, job, user, comp)
    template_name = 'housekeepapplicationsuser'
    template_content = []
    message = {
        to: [{email: email}],
        subject: "Excellara - You have a match needing attention!",
        merge_vars: [
            {
                rcpt: email,
                vars: [
                    {
                        name: 'JOB', content: job
                    },
                    {
                        name: 'USER', content: user
                    },
                    {
                        name: 'COMP', content: comp
                    },
                    {
                        name: 'NEXT_STEP', content: matched_jobs_users_url
                    }
                ]
            }
        ]
    }
    mandrill_client.messages.send_template template_name, template_content, message
  end

  def housekeepapplicationscomp(email, job, user, comp)
    template_name = 'housekeepapplicationscomp'
    template_content = []
    message = {
        to: [{email: email}],
        subject: "Excellara - You have a match needing attention!",
        merge_vars: [
            {
                rcpt: email,
                vars: [
                    {
                        name: 'JOB', content: job
                    },
                    {
                        name: 'USER', content: user
                    },
                    {
                        name: 'COMP', content: comp.name
                    },
                    {
                        name: 'NEXT_STEP', content: activity_companies_url(comp)
                    }
                ]
            }
        ]
    }
    mandrill_client.messages.send_template template_name, template_content, message
  end

  def postjobs(email, comp)
    template_name = 'postjobs'
    template_content = []
    message = {
        to: [{email: email}],
        subject: "Excellara - It's time to post jobs!",
        merge_vars: [
            {
                rcpt: email,
                vars: [
                    {
                        name: 'COMP', content: comp
                    },
                    {
                        name: 'NEXT_STEP', content: new_job_posting_url
                    }
                ]
            }
        ]
    }
    mandrill_client.messages.send_template template_name, template_content, message
  end

  def jobssuggestedtousers(email, user, jobtitles, joblinks)
    job1t = nil
    job2t = nil
    job3t = nil

    job1l = nil
    job2l = nil
    job3l = nil

    job1b = false
    job2b = false
    job3b = false

    if jobtitles.size > 0
      job1t = jobtitles[0]
      job1l = joblinks[0]
      job1b = true
    end

    if jobtitles.size > 1
      job2t = jobtitles[1]
      job2l = joblinks[1]
      job2b = true
    end

    if jobtitles.size > 2
      job3t = jobtitles[2]
      job3l = joblinks[3]
      job3b = true
    end

    template_name = 'jobssuggestedtousers'
    template_content = []
    message = {
        to: [{email: email}],
        subject: "Excellara - Job Suggestions This Week",
        merge_vars: [
            {
                rcpt: email,
                vars: [
                    {
                        name: 'USER', content: user
                    },
                    {
                        name: 'JOB1T', content: job1t
                    },
                    {
                        name: 'JOB1L', content: job1l
                    },
                    {
                        name: 'JOB1B', content: job1b
                    },
                    {
                        name: 'JOB2T', content: job2t
                    },
                    {
                        name: 'JOB2L', content: job2l
                    },
                    {
                        name: 'JOB2B', content: job2b
                    },
                    {
                        name: 'JOB3T', content: job3t
                    },
                    {
                        name: 'JOB3L', content: job3l
                    },
                    {
                        name: 'JOB3B', content: job3b
                    }
                ]
            }
        ]
    }
    mandrill_client.messages.send_template template_name, template_content, message
  end

  def jobssuggestedtocompanies(email, title,  comp, userNames, userLinks)
    user1n = nil
    user2n = nil
    user3n = nil
    user4n = nil
    user5n = nil

    user1l = nil
    user2l = nil
    user3l = nil
    user4l = nil
    user5l = nil

    user1b = nil
    user2b = nil
    user3b = nil
    user4b = nil
    user5b = nil

    template_name = 'jobssuggestedtocompanies'
    template_content = []
    message = {
        to: [{email: email}],
        subject: "Excellara - Candidate Suggestions For #{title}",
        merge_vars: [
            {
                rcpt: email,
                vars: [
                    {
                        name: 'COMP', content: comp
                    },
                    {
                        name: 'JOB', content: title
                    },
                    {
                        name: 'USER1N', content: user1n
                    },
                    {
                        name: 'USER1L', content: user1l
                    },
                    {
                        name: 'USER1B', content: user1b
                    },
                    {
                        name: 'USER2N', content: user2n
                    },
                    {
                        name: 'USER2L', content: user2l
                    },
                    {
                        name: 'USER2B', content: user2b
                    },
                    {
                        name: 'USER3N', content: user3n
                    },
                    {
                        name: 'USER3L', content: user3l
                    },
                    {
                        name: 'USER3B', content: user3b
                    },
                    {
                        name: 'USER4N', content: user4n
                    },
                    {
                        name: 'USER4L', content: user4l
                    },
                    {
                        name: 'USER4B', content: user4b
                    },
                    {
                        name: 'USER5N', content: user5n
                    },
                    {
                        name: 'USER5L', content: user5l
                    },
                    {
                        name: 'USER5B', content: user5b
                    },
                ]
            }
        ]
    }
    mandrill_client.messages.send_template template_name, template_content, message
  end

end
