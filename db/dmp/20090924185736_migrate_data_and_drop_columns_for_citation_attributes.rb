class MigrateDataAndDropColumnsForCitationAttributes < ActiveRecord::Migration
  def self.up
    Citations::CitationsAttribute.delete_all

        #data migration
    Citations::Citation.find(:all).each do |cit|
      cit_attr = Citations::CitationsAttribute.new
      cit_attr.attributes.keys.each do |attr|
        cit_attr.send(attr+"=",cit.send(attr)) if cit.has_attribute?(attr)
      end
      cit_attr.save!
      cit.citations_attributes_id = cit_attr.id
      cit.save!
    end

    Citations::Publication.find(:all).each do |pub|
      cit_attr = Citations::CitationsAttribute.new
      cit_attr.attributes.keys.each do |attr|
        cit_attr.send(attr+"=",pub.send(attr)) if pub.has_attribute?(attr)
      end
      cit_attr.save!
      pub.citations_attributes_id = cit_attr.id
      pub.save!
    end
    #droping columns in next migration

  end

  def self.down
  end
end
