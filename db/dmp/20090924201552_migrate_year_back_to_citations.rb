class MigrateYearBackToCitations < ActiveRecord::Migration
  def self.up
    add_column :citation, :year, :integer
    rename_column :citation, :citations_attributes_id, :citations_attribute_id

    Citations::Citation.find(:all).each do |cit|
      puts cit.citations_attribute.inspect
      cit.year = cit.citations_attribute.year
      cit.save!
    end
    
    remove_column :citations_attributes, :year
  end

  def self.down
  end
end
