class CreateImageSpecimens < ActiveRecord::Migration
  def self.up
    create_table :image_specimens do |t|

      t.timestamps
    end
  end

  def self.down
    drop_table :image_specimens
  end
end
