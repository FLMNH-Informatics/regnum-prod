class CreateCitationsOthers < ActiveRecord::Migration
  def self.up
    create_table :citations_others do |t|

      t.timestamps
    end
  end

  def self.down
    drop_table :citations_others
  end
end
