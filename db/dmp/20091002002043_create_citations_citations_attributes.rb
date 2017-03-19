class CreateCitationsCitationsAttributes < ActiveRecord::Migration
  def self.up
    create_table :citations_citations_attributes do |t|

      t.timestamps
    end
  end

  def self.down
    drop_table :citations_citations_attributes
  end
end
