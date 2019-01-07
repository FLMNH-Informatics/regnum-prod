class Submission < ActiveRecord::Base

  self.table_name = "submissions"
  self.inheritance_column = false

  belongs_to :status
  has_many :status_changes
  belongs_to :user, :foreign_key => :submitted_by
  has_many :submission_citation_attachments

  attr_accessible :name, :authors, :comments, :establish, :preexisting, :clade_type, :specifiers, :citations, :submitted_by
  attr_accessor :status_comments #editors comments for status changes

  #scope :submitted, where("status_id <> 4")
  #scope :approved, where("status_id = 4")
  @current_time = Time.now

  before_create lambda{ self.status_id = 1 }
  before_create :check_serialized

  after_find :check_serialized
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

  private

  # sets empty serialized fields
  def check_serialized
    ####remember you can assign numerics as keys in ruby a hash
    #
    # Authors
    # auths = [];
    # if (self.authors.nil? or self.authors.is_a? String)
    #   self.authors = {0=>{}};
    # end

    ####
    # Citations
#     cits = {
#         #only one citation
#         primary_phylogeny:  {},
#         preexisting:        {},
#         #many citations
#         description:  { 0=>{} },
#         phylogeny:    { 0=>{} }
#     }
# byebug
#     if self.citations == nil
#       # self.citations = cits
#     else
#       cits.each{|k,v| self.citations[k]=v unless self.citations.has_key?(k)}
#     end

    ####
    # Specifiers
    # if self.specifiers == nil
    #   self.specifiers = {0=>{}}
    # end
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
