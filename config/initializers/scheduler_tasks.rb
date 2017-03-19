scheduler = Rufus::Scheduler.new

scheduler.every "1h", :first_in => '1m' do 
 # BioportalOntology.synchronize_ontologies
end