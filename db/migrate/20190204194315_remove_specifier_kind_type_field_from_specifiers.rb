class RemoveSpecifierKindTypeFieldFromSpecifiers < ActiveRecord::Migration
  def up
    Submission.all.each do |submission|
      submission.specifiers.each { |specifier| specifier.delete('specifier_kind_type') if specifier.has_key? 'specifier_kind_type' }
      submission.save!
    end
  end

  def down
  end
end
