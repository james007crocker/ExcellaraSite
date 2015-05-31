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

  validates :years, numericality: { only_integer: true }, inclusion: { in: 1..100, :message => ' must be greater than 0' }, on: :update #, presence: true


  acts_as_taggable_on :skills, :lookings, :educations


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

  filterrific(
      default_filter_params: { sorted_by: 'created_at_desc' },
      available_filters: [
          :sorted_by,
          :search_query,
          :with_location,
          :with_sector
      ]
  )
  self.per_page = 10

  scope :sorted_by, lambda { |sort_option|
                    direction = (sort_option =~ /desc$/) ? 'desc' : 'asc'
                    case sort_option.to_s
                      when /^created_at_/
                        # Simple sort on the created_at column.
                        # Make sure to include the table name to avoid ambiguous column names.
                        # Joining on other tables is quite common in Filterrific, and almost
                        # every ActiveRecord table has a 'created_at' column.
                        order("users.created_at #{ direction }")

                      when /^name_/
                        # Simple sort on the name colums
                        order("LOWER(users.name) #{ direction }")
                      else
                        raise(ArgumentError, "Invalid sort option: #{ sort_option.inspect }")
                    end
                  }
  scope :search_query, lambda { |query|
                       return nil  if query.blank?

                       # condition query, parse into individual keywords
                       terms = query.downcase.split(/\s+/)

                       # replace "*" with "%" for wildcard searches,
                       # append '%', remove duplicate '%'s
                       terms = terms.map { |e|
                         (e.gsub('*', '%') + '%').gsub(/%+/, '%')
                       }
                       # configure number of OR conditions for provision
                       # of interpolation arguments. Adjust this if you
                       # change the number of OR conditions.
                       num_or_conds = 2
                       where(
                           terms.map { |term|
                             "(LOWER(users.name) LIKE ? OR LOWER(users.experience) LIKE ?)"
                           }.join(' AND '),
                           *terms.map { |e| [e] * num_or_conds }.flatten
                       )
                     }

  scope :with_location, lambda { |locations|
                        where(" users.location = ? ", locations )
                      }
  scope :with_sector, lambda { |sectors|
                      where(" users.sector = ? ", sectors)
                    }

  def self.options_for_sorted_by
    [
        ['Name (a-z)', 'name_asc'],
        ['Registration date (newest first)', 'created_at_desc'],
        ['Registration date (oldest first)', 'created_at_asc'],
    ]
  end
end
