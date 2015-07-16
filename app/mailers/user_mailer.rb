class UserMailer < ApplicationMailer
  default from: 'admin@excellara.com'
  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.user_mailer.account_activation.subject
  #

  def mandrill_client
    require 'mandrill'
    @mandrill_client ||= Mandrill::API.new "eRrpq1bHdEuYrCSDE_2j2Q"
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

end
