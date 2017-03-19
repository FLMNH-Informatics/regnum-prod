class AddForeignkeyToCitations < ActiveRecord::Migration
  def self.up
    execute <<-SQL
                    ALTER TABLE citations ADD FOREIGN KEY  (citations_attribute_id)  REFERENCES citation_attribute_triples(id)
             SQL
  end

  def self.down
  end
end
