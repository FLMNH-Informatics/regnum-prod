class CreateSpecifiers < ActiveRecord::Migration
  def self.up
    create_table :specifiers do |t|

      t.timestamps
    end
  end

  def self.down
    drop_table :specifiers
  end
end
