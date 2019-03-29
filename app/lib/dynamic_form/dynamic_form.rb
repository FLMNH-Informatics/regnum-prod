require File.dirname(__FILE__) +'/action_view/helpers/dynamic_form'

class ActionView::Base
  include DynamicForm
end
