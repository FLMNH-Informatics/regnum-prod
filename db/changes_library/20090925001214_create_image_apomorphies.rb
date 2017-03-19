class CreateImageApomorphies < ActiveRecord::Migration
  def self.up
    create_table :image_apomorphies do |t|

      t.timestamps
    end
  end

  def self.down
    drop_table :image_apomorphies
  end
end
