class CreateLegacyTaxas < ActiveRecord::Migration
  def self.up
    create_table :legacy_taxas do |t|

      t.timestamps
    end
  end

  def self.down
    drop_table :legacy_taxas
  end
end
