class Submission < ActiveRecord::Base
  MinimumCladeStandard                  = { 
      name: "Minimum Clade - Standard", 
      key: "minimum-clade_standard", 
      description: "A minimum-clade definition associates a name with the smallest clade that contains two or more internal specifiers. Specifiers can be species or specimens." }
  MinimumCladeDirectlySpecifiedAncestor = { 
      name: "Minimum Clade - Directly Specified Ancestor", 
      key: "minimum-clade_directly_specified_ancestor", 
      description: "A directly-specified-ancestor definition is a special case of the minimum-clade definition in which the ancestor in which the clade originated is specified directly rather than indirectly through its descendants." }
  MaximumCladeStandard                  = { 
      name: "Maximum Clade - Standard", 
      key: "maximum-clade_standard", 
      description: "A maximum-clade associates a name with the largest clade that contains one or more internal specifiers but does not contain one or more external specifiers." }
  ApomorphyBasedStandard                = { 
      name: "Apomorphy Based - Standard", 
      key: "apomorphy-based_standard", 
      description: "An apomorphy-based definition associates a name with a clade originating in the first ancestor to evolve a specified apomorphy that was inherited by one or more internal specifiers." }
  MinimumCrownClade                     = { 
      name: "Minimum Crown Clade", 
      key: "minimum-crown-clade", 
      description: "A minimum crown clade definition is a minimum clade where all of the internal specifiers are extant." }
  MaximumCrownClade                     = { 
      name: "Maximum Crown Clade", 
      key: "maximum-crown-clade", 
      description: "A maximum crown clade definition is a maximum clade where at least one of the internal specifiers are extant." }
  ApomorphyModifiedCrownClade           = { 
      name: "Apomorphy Modified Crown Clade", 
      key: "apomorphy-modified_crown_clade", 
      description: "An apomorphy-modified-crown clade is a minimum-clade modified by the use of an apomorphy to define the name of a crown clade." }
  MaximumTotalClade                     = { 
      name: "Maximum Total Clade", 
      key: "maximum-total-clade", 
      description: "A maximum total-clade definition is maximum clade where least one of the internal specifiers and all of the external specifiers are extant." }
  CrownBasedTotalClade                  = { 
      name: "Crown Based - Total Clade", 
      key: "crown-based_total_clade", 
      description: "A crown based total clade is the total clade of a crown clade" }

  CladeTypes = [
      Submission::MinimumCladeStandard,
      Submission::MinimumCladeDirectlySpecifiedAncestor,
      Submission::MaximumCladeStandard,
      Submission::ApomorphyBasedStandard,
      Submission::MinimumCrownClade,
      Submission::MaximumCrownClade,
      Submission::ApomorphyModifiedCrownClade,
      Submission::MaximumTotalClade,
      Submission::CrownBasedTotalClade
  ]
  
  
  CrownSpecifiers = [
      Submission::MinimumCladeStandard,
      Submission::MinimumCrownClade,
      Submission::MaximumCrownClade,
      Submission::ApomorphyModifiedCrownClade
  ]

  self.table_name = "submissions"
  self.inheritance_column = false

  belongs_to :user, :foreign_key => :submitted_by
  belongs_to :status
  has_many :status_changes
  has_many :submission_citation_attachments

  attr_accessible :name, :authors, :comments, :establish, :preexisting, :clade_type, :specifiers, :citations, :submitted_by
  attr_accessor :status_comments #editors comments for status changes

  #scope :submitted, where("status_id <> 4")
  #scope :approved, where("status_id = 4")
  @current_time = Time.now

  before_create lambda{ self.status_id = 1 }
  before_create :check_serialized
  before_save :remove_invalid_specifiers

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
  scope :crown_specifiers, -> { where(clade_type: Submission::CrownSpecifiers.map{|x| x[:key] }).order(:name) }
  scope :crown_specifiers_ordered_by_clade_type, -> { where(clade_type: Submission::CrownSpecifiers.map{|x| x[:key] }).order(:clade_type, :name) }

  #Submission::MinimumCrownClade,
  #    Submission::MaximumCrownClade,
  #    Submission::ApomorphyModifiedCrownClade


  #scope :approved, where(:status_id => Status.where(:status => 'approved').first.id)
  
  def temp_id
    #reverting to just plain id, see issue #89
    self.id
  end

  def name_id
    "#{name}|regnum_id=#{id}"
  end

  def name_and_clade_type
    "#{name} (#{clade_type_name})"
  end

  def registration_number
    #reverting to just plain id, see issue #89
    temp_id
  end

  def clade_type_name
    Submission::CladeTypes.find{ |ct| clade_type == ct[:key] }[:name]
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

  def submitted_at
    statuses = self.status_changes.all.sort{|a,b| b<=>a}.first
    if statuses.nil?
      "Not submitted"
    else
      "#{statuses.status.status} - #{statuses.changed_at}"
    end
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

  def is_submitted?
    self.status.status == "submitted"
  end

  def is_unsubmitted?
    self.status.status == "unsubmitted"
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
#
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
