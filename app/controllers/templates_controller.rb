class TemplatesController < ApplicationController
  
  helper :my_submission
  before_filter :requires_logged_in
  
  attr_accessor :templates

  def initialize
    @templates = { 
  	  'citation' => 'shared/new_citation', 
      'book_citation' => 'shared/new_book_citation',
      'book_section_citation' => 'shared/new_book_section_citation',
      'journal_citation' => 'shared/new_journal_citation',
  	  'specifier' => 'shared/new_specifier',
      'species_specifier' => 'shared/new_species_specifier',
      'specimen_specifier' => 'shared/new_specimen_specifier',
      'apomorphy_specifier' => 'shared/new_apomorphy_specifier',
  	  'synonyms' => 'shared/synonyms_table',
      'special_characters' => 'my_submission/special_characters'
    }
  end
  
  def load    
    to_load = params[:template]
    render :partial => @templates[to_load] , :layout => false
  end

end