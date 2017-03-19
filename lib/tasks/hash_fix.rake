 #require '../config/environment'

namespace :hash_fix do

  task :fix_citation_keys => :environment do
    subs = Submission.all

    subs.each do |sub|
      sub.citations.each do |key,val|
        cits = val #sub.citations['phylogeny']
        cits.each do |ind,cit|
          #fix for title
          if cit.has_key?('article_title')
             v = sub.citations[key][ind].delete('article_title')
             sub.citations[key][ind]['title'] = v
          end

          if cit.has_key?('type')
            v = sub.citations[key][ind].delete('type')
            sub.citations[key][ind]['citation_type']  = v
          end
          ##
      	end
      end

      sub.save
    end
  end
  
  task :fix_specifier_keys => :environment do
    subs = Submission.all
    subs.each do |sub|
      sub.specifiers.each do |ind,spec|
        ##fix for type
        if spec.has_key?('type')
          v = sub.specifiers[ind].delete('type')
          sub.specifiers[ind]['specifier_type'] = v
        end
        ##
        if spec.has_key?('kind')
          v = sub.specifiers[ind].delete('kind')
          sub.specifiers[ind]['specifier_kind'] = v
        end
        ##
        if spec.has_key?('kind_type')
          v = sub.specifiers[ind].delete('kind_type')
          sub.specifiers[ind]['specifier_kind_type'] = v
        end
        ##
      end
      sub.save
    end
  end

  task :make_all_citations_array => :environment do 
    subs = Submission.all
    subs.each do |sub|  
      keys = sub.citations.keys   
      keys.each do |key|
        if sub.citations[key].is_a?(Hash) && key != 'phylogeny'
          ar = {}  
          sub.citations[key].each do |k,v|
            ar[k] = v            
          end
          sub.citations[key].clear
          sub.citations[key]['0'] = ar
          
        end  
      end
      sub.save
    end
  end

end