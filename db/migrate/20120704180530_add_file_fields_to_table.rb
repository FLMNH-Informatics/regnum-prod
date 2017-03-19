class AddFileFieldsToTable < ActiveRecord::Migration
  def self.up

    create_table :submission_citation_attachments do |t|
      t.integer :id
      t.integer :submission_id
      t.string  :citation_type
    end

    add_attachment :submission_citation_attachments, :file
  end

  def self.down
  end
end
