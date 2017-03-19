class Submission < ActiveRecord::Base

  self.table_name = "submissions"
  self.inheritance_column = false

  attr_accessible :name, :authors, :comments, :establish, :preexisting, :type, :specifiers, :citations
  attr_accessor :status_comments #editors comments for status changes

  has_many :submission_citation_attachments

  belongs_to :status
  has_many :status_changes
  belongs_to :user, :foreign_key => :submitted_by
  
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
  #citations and specifiers are stored as hashes
  #also conveniently makes all the fields searchable on a single column
  serialize :citations, Hash
  serialize :specifiers, Hash
  
  scope :opt_in, where(:establish => true)
  scope :opt_out, where(:establish => false)
  #scope :approved, where(:status_id => Status.where(:status => 'approved').first.id)
  
  def temp_id
    #registration number for users
    #number is based on table primary key just with padding up to 9 numbers
    "#{self.id.to_s.rjust(10,'0')}"
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

  private

  # sets empty serialized fields
  def check_serialized
    ####remember you can assign numerics as keys in ruby a hash
    cits = {'preexisting' => {0=>{}}, 'description' => {0=>{}}, 'phylogeny' => {0=>{}}, 'primary-phylogeny' => {0=>{}}}
    specs = {0=>{}}
    ####
    if self.citations == nil
      self.citations = cits
    else
      cits.each{|k,v| self.citations[k]=v unless self.citations.has_key?(k)}
    end
    ####
    if self.specifiers == nil
      self.specifiers = specs
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
