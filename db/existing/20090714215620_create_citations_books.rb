class CreateCitationsBooks < ActiveRecord::Migration
  def self.up
    create_table :citations_books do |t|

      t.timestamps
    end
  end

  def self.down
    drop_table :citations_books
  end
end
