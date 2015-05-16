class User < ActiveRecord::Base
  attr_accessor :remember_token, :activation_token, :reset_token, :picture
  before_create :create_activation_digest
  before_save { self.email = email.downcase }

  validates :name, presence: true, length: { maximum: 50 }
  validate :firstLastProvided?, :on => :create

  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates :email, presence: true, length: { maximum: 255 },
      format: { with: VALID_EMAIL_REGEX }, uniqueness: { case_sensitive: false}
  validate :emailTaken?, :on => :create
  validates :location,  length:  { maximum: 20 }#,presence: true
  validate :userLocation?, :unless => Proc.new { |user| user.location.nil? }

  #validates :experience, presence: true
  validate :userExperience?, :unless => Proc.new { |user| user.experience.nil? }
  #validates :accomplishment, length: { minimum: 5}

  mount_uploader :picture, PictureUploader
  validate  :picture_size

  mount_uploader :resume, ResumeUploader
  validate  :resume_size

  has_secure_password
  validates :password, length: { minimum: 6, maximum: 20 }, :unless => Proc.new { |company| company.password.nil? }

  validates :profession, presence: true, length: { minimum: 4, maximum: 25 } , :on => :update

  def User.digest(string)
    cost = ActiveModel::SecurePassword.min_cost ? BCrypt::Engine::MIN_COST :
        BCrypt::Engine.cost
    BCrypt::Password.create(string, cost: cost)
  end

  def User.new_token
    SecureRandom.urlsafe_base64
  end

  def getExperience
    return self.experience.nil? ? " " : self.experience
  end
  def remember
    self.remember_token = User.new_token
    update_attribute(:remember_digest, User.digest(remember_token))
  end

  def forget
    update_attribute(:remember_digest, nil)
  end

  def authenticated?(attribute, token)
    digest = send("#{attribute}_digest")
    return false if digest.nil?
    BCrypt::Password.new(digest).is_password?(token)
  end

  def activate
    update_attribute(:activated, true)
    update_attribute(:activated_at, Time.zone.now)
  end

  def send_activation_email
    UserMailer.account_activation(self).deliver_now
  end

  def create_reset_digest
    self.reset_token = User.new_token
    update_attribute(:reset_digest,  User.digest(reset_token))
    update_attribute(:reset_sent_at, Time.zone.now)
  end

  def send_password_reset_email
    UserMailer.password_reset(self).deliver_now
  end

  def password_reset_expired?
    reset_sent_at < 2.hours.ago
  end

  private

    def create_activation_digest
      self.activation_token = User.new_token
      self.activation_digest = User.digest(activation_token)
    end

    def picture_size
      if picture.size > 5.megabytes
        errors.add(:picture, "should be less than 5MB")
      end
    end

    def resume_size
      if resume.size > 5.megabytes
        errors.add(:resume, "should be less than 5MB")
      end
    end

    def userLocation?
      if self.activated && self.location.blank?
        errors.add(:location, "should  be present")
      end
    end

    def userExperience?
      if self.activated && self.experience.blank?
        errors.add(:experience, "should  be present")
      end
    end

    def emailTaken?
      unless Company.where(:email => self.email).size == 0
        errors.add(:email, "is already in use")
      end
    end

    def firstLastProvided?
      if self.name.split(' ').length < 2
        errors.add(:name, "should contain a first and last name")
      end
    end
end
