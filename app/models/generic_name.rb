class GenericName < ActiveRecord::Base
  self.table_name = "cladenames"
  belongs_to :users
  #belongs_to :preexisting_name , :class_name => "LegacyTaxa"
  belongs_to :user , :class_name => "User"
  belongs_to :submission, :class_name => "Submission"
  has_many :phylogeny_citations, :class_name => 'Citation', :foreign_key =>  'cladename_id'


  validates_presence_of    :name
  validates_length_of       :name,    :within => 3..40
  validates_uniqueness_of   :name 
  #validates_numericality_of :preexisting_name_id , :if => Proc.new { |cladename| debugger cladename.preexisting_name_id.nil? || cladename.preexisting_name_id > 0   }
  validates_numericality_of :definition_type , :if => :definition_validate , :on => :update



=begin
  def validate

    if !( preexisting_name_id.nil? || preexisting_name_id > 0)
      if  preexisting_name_id == -1
       errors.add(:preexisting_name_id, "Preexisting name can't be blank")
      else
        errors.add(:preexisting_name_id, "select at least one of the checkboxes")
      end
    end
  end
=end
 

  def definition_validate    
    if definition_type.nil? || !(definition_type > 0)
        if definition_type != -1
          errors.add(:definition_type, "Please select a definition Type")
        end
    end
  end
  
end
