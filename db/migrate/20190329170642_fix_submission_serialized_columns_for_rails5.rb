class FixSubmissionSerializedColumnsForRails5 < ActiveRecord::Migration[5.0]
  # this migration addresses the issue in Rails 5 that ActionController::Parameters no longer subclasses Hash,
  # which invalidates all seralized columns that, in previous versions of rails, contains ActionController::Parameters
  #
  # first we need to create columns to hold the old data, in case we need to rollback the migration
  # then, we'll use a TempSubmission simplified class of Submissions table

  class TempSubmission < ApplicationRecord
    self.table_name = 'submissions'
    serialize :authors_old
    serialize :citations_old
    serialize :specifiers_old

    serialize :authors
    serialize :citations
    serialize :specifiers

  end


  def up
    #rename columns to store old data serialized as ActionController:Parameters
    rename_column :submissions, :authors, :authors_old
    rename_column :submissions, :citations, :citations_old
    rename_column :submissions, :specifiers, :specifiers_old

    #add new columns to hold new data
    add_column :submissions, :authors, :text unless column_exists? :submissions, :authors
    add_column :submissions, :citations, :text unless column_exists? :submissions, :citations
    add_column :submissions, :specifiers, :text unless column_exists? :submissions, :specifiers

    #fix data
    TempSubmission.all.each do |sub|
      #fix authors, citations, specifiers - convert to regular hash
      # authors is an array of ActionController::Parameters
      sub.authors = sub.authors_old.nil? ? nil : sub.authors_old.map { |auth| auth.is_a?(ActionController::Parameters) ? auth.to_unsafe_h.to_h : auth }
      # citations is ActionController::Parameters
      sub.citations = sub.citations_old.is_a?(ActionController::Parameters) ? sub.citations_old.to_unsafe_h.to_h : sub.citations_old
      # specifiers is an array of ActionController::Parameters
      sub.specifiers = sub.specifiers_old.nil? ? nil : sub.specifiers_old.map { |s| s.is_a?(ActionController::Parameters) ? s.to_unsafe_h.to_h : s }
      sub.save!
    end
  end

  def down
    TempSubmission.all.each do |sub|
      sub.authors    = sub.authors_old
      sub.citations  = sub.citations_old
      sub.specifiers = sub.specifiers_old
      sub.save!
    end

    remove_column :submission, :authors_old if column_exists? :submissions, :authors_old
    remove_column :submission, :citations_old if column_exists? :submissions, :citations_old
    remove_column :submission, :specifiers_old if column_exists? :submissions, :specifiers_old
  end
end
