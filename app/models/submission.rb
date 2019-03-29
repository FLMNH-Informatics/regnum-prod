class Submission < ApplicationRecord

  self.table_name = "submissions"
  self.inheritance_column = false

  belongs_to :status
  has_many :status_changes
  belongs_to :user, :foreign_key => :submitted_by
  has_many :submission_citation_attachments

  # attr_accessible :name, :authors, :comments, :establish, :preexisting, :clade_type, :specifiers, :citations, :submitted_by #removed in rails 5
  attr_accessor :status_comments #editors comments for status changes

  #scope :submitted, where("status_id <> 4")
  #scope :approved, where("status_id = 4")
  @current_time = Time.now

  before_create lambda{ self.status_id = 1 }
  before_save :remove_invalid_specifiers

  after_find lambda{ @current_status = self.status_id }

  #citation
  before_update lambda{ self.updated_at = @current_time }
  before_update :check_status_change
  # authors, citations and specifiers are stored as hashes
  # this conveniently makes all the fields searchable on a single column
  serialize :authors, Array
  serialize :citations, Hash
  serialize :specifiers, Array
  
  scope :opt_in, -> { where(establish: true) }
  scope :opt_out, -> { where(establish: false) }
  #scope :approved, where(:status_id => Status.where(:status => 'approved').first.id)
  
  def temp_id
    #reverting to just plain id, see issue #89
    self.id
  end

  def registration_number
    #reverting to just plain id, see issue #89
    temp_id
  end

  def current_status_comments
    stat = StatusChange.find_by_submission_id_and_status_id_and_changed_at(self.id, self.status_id, self.updated_at)
    if stat == nil
      ''
    else
      stat.comments
    end
  end
  
  def submitted_by_user?(current_user_id)
    self.submitted_by == current_user_id
  end

  def self.handle_save params
    params = params.to_unsafe_h #change in rails 5, need to permit all parameters, this is the fastest way but might be unsafe
    submission = Submission.find(params[:submission_id])
    submission.citations           = params[:citations] if params.has_key?(:citations)
    submission.specifiers          = params[:specifiers] if params.has_key?(:specifiers)
    submission.preexisting         = params[:preexisting] == 'null' ? false : params[:preexisting]
    submission.comments            = params[:comments]
    submission.preexisting_authors = params[:preexisting_authors]
    submission.preexisting_code    = params[:preexisting_code]
    submission.clade_type          = params[:clade_type]
    submission.definition          = params[:definition]
    submission.name                = params[:name]
    submission.authors             = params[:authors]
    submission.name_string         = params[:name_string]
    submission.qualifying_clause   = params[:qualifying_clause]
    submission.abbreviation        = HTMLEntities.new.decode(params[:abbreviation])
    submission.status_id           = Status.find_by_status('submitted').id if params[:subaction] == 'submit'
    submission.save!
    submission
  end

  def is_apomorphy?
    self.clade_type&.include? "apomorphy"
  end

  private

  def remove_invalid_specifiers
    unless self.is_apomorphy?
      self.specifiers.delete_if { |specifier| specifier["specifier_type"] == "apomorphy" }
    end
  end

  # create new status change record on status change
  def check_status_change
    if self.status_id != @current_status
      sc = StatusChange.new
      sc.submission_id = self.id
      sc.status_id = self.status_id
      sc.changed_at = @current_time 
      sc.comments = status_comments
      sc.save
      #give sub a global id if approved
      if self.status.eq?('approved')
        self.guid = generate_guid(@current_time)
      end
    end
  end
  
  def generate_guid(time=nil)
    UUIDTools::UUID.timestamp_create(time).to_s
  end
  
end
