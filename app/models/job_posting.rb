class JobPosting < ActiveRecord::Base
  belongs_to :company
  has_many :applicants, dependent: :destroy
  #default_scope -> { order(created_at: :desc) }
  validates :title, presence: true, length: { maximum: 30 }
  validates :location, presence: true, length: { maximum: 20 }
  validates :description, presence: true

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
                        order("job_postings.created_at #{ direction }")

                      when /^name_/
                        # Simple sort on the name colums
                        order("LOWER(job_postings.title) #{ direction }, LOWER(job_postings.title) #{ direction }")
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
                             "(LOWER(job_postings.title) LIKE ? OR LOWER(job_postings.description) LIKE ?)"
                           }.join(' AND '),
                           *terms.map { |e| [e] * num_or_conds }.flatten
                       )
                     }

  scope :with_location, lambda { |locations|
                        where(" job_postings.location = ? ", locations )
                      }
  scope :with_sector, lambda { |types|
                        where(" job_postings.type = ? ", types)
                    }

  def self.options_for_sorted_by
    [
        ['Title (a-z)', 'title_asc'],
        ['Registration date (newest first)', 'created_at_desc'],
        ['Registration date (oldest first)', 'created_at_asc'],
    ]
  end

end
