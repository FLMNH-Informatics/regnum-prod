class AddIndexIdToSubAttachments < ActiveRecord::Migration
  def self.up
    add_column :submission_citation_attachments, :index_id, :integer
  end

  def self.down
  end
end
