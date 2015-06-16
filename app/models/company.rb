class Company < ActiveRecord::Base
  has_many :job_postings, dependent: :destroy
  attr_accessor :remember_token, :activation_token, :reset_token
  before_create :create_activation_digest
  before_save { self.email = email.downcase }
  validates :name, presence: true, length: { maximum: 50 }

  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates :email, presence: true, length: { maximum: 255 },
            format: { with: VALID_EMAIL_REGEX }, uniqueness: { case_sensitive: false}
  validate :emailTaken?, :on => :create

  validates :location, length:  { maximum: 20 } #, presence: true
  validate :CompLocation?, :unless => Proc.new { |company| company.location.nil? }

  validates :size, numericality: { only_integer: true }, inclusion: { in: 1..10000, :message => ' must be greater than 0' }, on: :update #, presence: true
  #validate :CompSize?

  #validates :description, presence: true
  validate :CompDescription?, :unless => Proc.new { |company| company.description.nil? }

  validates :website, length: { maximum: 20 }
  validate :CompWebsite? , :unless => Proc.new { |company| company.description.nil? }

  has_secure_password
  validates :password, length: { minimum: 6, maximum: 20 }, :unless => Proc.new { |company| company.password.nil? }


  mount_uploader :picture, PictureUploader
  validate  :picture_size

  def Company.digest(string)
    cost = ActiveModel::SecurePassword.min_cost ? BCrypt::Engine::MIN_COST :
        BCrypt::Engine.cost
    BCrypt::Password.create(string, cost: cost)
  end

  def Company.new_token
    SecureRandom.urlsafe_base64
  end

  def remember
    self.remember_token = Company.new_token
    update_attribute(:remember_digest, User.digest(remember_token))
  end

  def authenticated?(attribute, token)
    digest = send("#{attribute}_digest")
    return false if digest.nil?
    BCrypt::Password.new(digest).is_password?(token)
  end

  def forget
    update_attribute(:remember_digest, nil)
  end

  def activate
    update_attribute(:activated, true)
    update_attribute(:activated_at, Time.zone.now)
  end

  def send_activation_email
    UserMailer.account_activation(self).deliver_now
  end

  def create_reset_digest
    self.reset_token = Company.new_token
    update_attribute(:reset_digest,  Company.digest(reset_token))
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
      self.activation_token = Company.new_token
      self.activation_digest = Company.digest(activation_token)
    end

    def picture_size
      if picture.size > 5.megabytes
        errors.add(:picture, "should be less than 5MB")
      end
    end

    def CompSize?
      if self.size.blank?
        errors.add(:size, "should be an number")
      end
    end

    def is_number?(string)
     true if Float(string) rescue false
    end

    def CompWebsite?
      if self.activated && self.website.blank?
        errors.add(:website, "should  be present")
      end
    end

    def CompLocation?
      if self.activated && self.location.blank?
        errors.add(:location, "should  be present")
      end
    end

    def CompDescription?
      if self.activated && self.description.blank?
        errors.add(:description, "should be present")
      end
    end

    def emailTaken?
      unless User.where(:email => self.email).size == 0
        errors.add(:email, "is already in use")
      end
    end
end
