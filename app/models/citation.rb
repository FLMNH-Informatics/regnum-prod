class Citation < ApplicationRecord
  belongs_to :user, foreign_key: :created_by_id
  belongs_to :created_by, class_name: 'User'
  belongs_to :citation_type

  serialize :authors, Array
  serialize :editors, Array
  serialize :series_editors, Array

  before_create lambda { self.created_at = Time.now }
  before_update lambda { self.updated_at = Time.now }

  def is_journal?
    citation_type.is_journal?
  end

  def is_book?
    citation_type.is_book?
  end

  def is_book_section?
    citation_type.is_book_section?
  end

  def self.create_from_json json, user
    if is_empty_citation_from_json?(json)
      return nil
    end

    citation_type = CitationType.find_by_citation_type(json[:citation_type])
    Citation.new do |cit|
      cit.citation_type  = citation_type
      cit.authors        = json["authors"].keep_if { |auth| is_valid_author?(auth) }
      unless citation_type.is_journal?
        cit.editors = json["editors"].keep_if { |auth| is_valid_author?(auth) }
      end
      if citation_type.is_book_section?
        cit.series_editors = json["series_editors"].keep_if { |auth| is_valid_author?(auth) }
      end
      string_fields_for_citation_type(citation_type).each do |field|
        cit[field] = json[field] unless json[field].blank?
      end
      cit.created_by = user
    end
  end

  def self.is_empty_citation_from_json? cit
    return true if cit.nil?
    cit["authors"].all? { |author| is_invalid_author? author } and
        cit["editors"].all? { |author| is_invalid_author? author } and
        cit["series_editors"].all? { |author| is_invalid_author? author } and
        string_fields.all? { |field| cit[field].blank? }
  end

  def self.is_invalid_author? author
    author[:last_name].blank? and author[:first_name].blank? and author[:last_name].blank?
  end

  def self.is_valid_author? author
    !is_invalid_author? author
  end

  private

  # @param [ApplicationRecord::CitationType] citation_type
  def self.string_fields_for_citation_type(citation_type)
    return journal_string_fields if citation_type.is_journal?
    return book_string_fields if citation_type.is_book?
    return book_section_string_fields if citation_type.is_book_section?
  end

  def self.string_fields
    %w(title publisher figure year edition number journal city volume pages keywords isbn doi url)
  end

  def self.book_string_fields
    string_fields - journal_only_string_fields - book_section_only_string_fields
  end

  def self.book_section_string_fields
    string_fields - journal_only_string_fields
  end

  def self.journal_string_fields
    string_fields - %w(publisher city) - book_section_only_string_fields
  end

  def self.journal_only_string_fields
    %w(figure journal isbn)
  end

  def self.book_section_only_string_fields
    %w(series_editor section_title)
  end
end