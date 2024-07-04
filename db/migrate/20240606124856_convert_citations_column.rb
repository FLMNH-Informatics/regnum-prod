class ConvertCitationsColumn < ActiveRecord::Migration[6.1]
  
  class Submissioner < ActiveRecord::Base
    self.table_name = 'submissions'
  end

  def up
    record = Submissioner.all
    record.each do |r|
      begin
        authors = YAML.load(r.authors).to_unsafe_h.to_h.to_yaml 
        r.authors = authors 
      rescue StandardError
        puts 'no worries author'
      end 
      begin
        citations = YAML.load(r.citations).to_unsafe_h.to_h.to_yaml 
        r.citations = citations 
      rescue StandardError
        puts 'no worries citations'
      end 
      begin 
        specifiers = [YAML.load(r.specifiers)[0].to_unsafe_h.to_h].to_yaml
        r.specifiers = specifiers 
      rescue StandardError
        puts 'no worries specifiers'
      end 
      r.save!
    end 

  end

  def down
    raise ActiveRecord::IrreversibleMigration
  end
end
