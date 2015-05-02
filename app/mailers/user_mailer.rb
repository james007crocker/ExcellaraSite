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
    if Rails.env.production?
      @link = "https://excellara-test.herokuapp.com/resume?id=" + @sender.id.to_s
    else
      @link = "http://localhost:3000/resume?id=" + @sender.id.to_s
    end
    if @receiver.kind_of? User
      subject_string = "Excellara Match: " + @job.title + " at " + @sender.name
    else
      subject_string = "Excellara Match: " + @sender.name + " for " + @job.title
    end
    mail to: receiver.email, subject: subject_string
  end

  def message_email(name, email, message)
    @name = name;
    @email = email;
    @message = message;
    mail to: "lauren@excellara.com", subject: "Excellara - Contact Page Message"
  end
end
