class CreateCitationsJournals < ActiveRecord::Migration
  def self.up
    create_table :citations_journals do |t|

      t.timestamps
    end
  end

  def self.down
    drop_table :citations_journals
  end
end
