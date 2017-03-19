require Rails.root.to_s + '/lib/respond_to_parent/responds_to_parent'
ActionController::Base.send :include, RespondsToParent
