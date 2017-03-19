module PhenotypesHelper
  def generate_string_from_differentiae pheno_id, col,entity
    return "" if entity.nil?
    recs = Differentia.where("#{col} = ?",pheno_id)
    recs.inject(entity) do |mem,rec|
      mem + "^#{rec.relation_term.try(:label)}(#{rec.ontology_term.try(:label)})"
    end
  end

end