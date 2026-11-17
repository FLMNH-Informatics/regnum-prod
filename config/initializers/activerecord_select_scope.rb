
Rails.application.config.to_prepare do
  ActiveRecord::Base.include(::SyncRecords::SelectScope)
end