class UserMailer < ApplicationMailer

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.user_mailer.account_activation.subject
  #
  def account_activation(receiver)
    @receiver = receiver

    mail to: receiver.email, subject: "Excellara Account Activation"
  end

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.user_mailer.password_reset.subject
  #
  def password_reset(receiver)
    @receiver = receiver

    mail to: receiver.email, subject: "Excellara Password Reset"
  end

  def match_email(sender, receiver, job, text, sendresume)
    @receiver = receiver
    @sender = sender
    @job = job
    @text = text
    @sendresume = sendresume
    #if Rails.env.production?
      #@link = "https://excellara-test.herokuapp.com/resume?id=" + @sender.id.to_s
    #else
      #@link = "http://localhost:3000/resume?id=" + @sender.id.to_s
    #end
    if @receiver.kind_of? User
      subject_string = "Excellara Match: " + @job.title + " at " + @sender.name
      mail to: @receiver.email, subject: subject_string
    else
      subject_string = "Excellara Match: " + @sender.name + " for " + @job.title
      mail to: @receiver.email, subject: subject_string
    end
  end

  def match_email2(receiver, sender, job, text)
    @receiver = receiver
    @sender = sender
    @job = job
    @text = text
    if @receiver.kind_of? User
      subject_string = "Excellara Match: " + @job.title + " at " + @sender.name
      mail to: @receiver.email, subject: subject_string
    else
      subject_string = "Excellara Match: " + @sender.name + " for " + @job.title
      mail to: @receiver.email, subject: subject_string
    end
  end

  def message_email(name, email, message)
    @name = name;
    @email = email;
    @message = message;
    mail to: "lauren@excellara.com", subject: "Excellara - Contact Page Message"
  end

  def compsuggest(sender, receiver, job)
    @receiver = receiver
    @sender = sender
    @job = job
    mail to: @receiver.email, subject: "Excellara Job Interest: #{@job.title}"
  end

  def usersuggest(sender, receiver, job)
    @receiver = receiver
    @sender = sender
    @job = job
    mail to: @receiver.email, subject: "Excellara Job Interest: #{@job.title}"
  end

end
