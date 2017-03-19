class MoreCladenameChanges < ActiveRecord::Migration
  def self.up
    change_table :cladenames do |t|
      t.rename :preexisting_author, :preexisting_authors
      t.rename :comment, :comments
      t.string :abbreviation
      t.string :name_string
      t.index :guid
      t.remove :editor_comment, :peer_review
    end
  end

  def self.down
  end
end
