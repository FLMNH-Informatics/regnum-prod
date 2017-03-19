module TabsHelper

  def new_tabs
     [{:name => 'Create Submission', :path => new_submission_path},
      {:name => 'Accepted Sumissions', :path => accepted_path},
      {:name => 'Citations', :path => citations_index_path}
     ]
  end

  def tabs
    display_tabs = [:search]
    display_tabs << :my_submission if logged_in?
    #display_tabs << :phenotypes if logged_in?
    display_tabs << :submissions if logged_in? && (current_user.is_a_reviewer? || current_user.is_admin?) #.role.role_id == 4
    display_tabs << :admin if logged_in? && current_user.is_admin?
    display_tabs
  end


  # map for holding display and linking behavior of tabs
  @@nav_menu = {
    :primary => {
      :my_submission => {:text => "My Submissions", :controller => 'my_submission', :subnav => [ :cladename  ], :link => '/my_submission' },
      :phenotypes => {:text => "Phenotypes", :controller => 'phenotypes', :subnav => [ ], :link => '/phenotypes' },
      :submissions => { :text => "Review", :controller => 'submissions', :link => '/submissions' },
      :search => { :text =>"Search", :controller => 'search', :subnav => [  ], :link => '/search'} ,
      :admin => { :text => 'Admin', :controller => 'admin', :subnav => [:list_users, :add_user], :link => '/admin'}
    },
    :secondary => {
      :list_users => {:title => 'User List',:parent => :admin, :path => 'admin_path'} ,
      :add_user => {:title => 'Add User', :parent => :admin, :path => 'add_user_admin_path'},
      :cladename => { :title => "Create Submission",:subnav => [ :cladename , :definitiontype, :specifiers, :definition, :citation ], :parent => :my_submission, :path => 'new_submission_path' },
      :accepted  => { :title => "Accepted Submissions", :parent=> :my_submission, :path => 'accepted_url' },
    }
    
  }


  def generate_tabs
    controller_name = self.controller.controller_name
    result_str = "<div id='header'><ul id='primary'>"
    
    tabs.each do |tab|
      # send project_id as param to next controller only if it is a project specific controller
   
      # determine tab class for css display purposes
      tab_class = tab_class?(tab)

      # display tab
      result_str << "<li class='#{tab_class}'>"

      result_str << link_to_if(tab_class == 'top_tab active' || tab_class == 'top_tab current' , @@nav_menu[:primary][tab][:text], @@nav_menu[:primary][tab][:link])
      result_str << "</li>"

      @current_tab = tab if current_tab?(tab)

    end
    result_str <<  (logged_in? ? "<li class=\"top_tab active\"><a href=\"/logout\">Logout</a></li>" : "<li class=\"top_tab active\"><a href=\"/login\">Login</a></li>")
    result_str << "</ul></div>"
  end

  
  def current_tab?(tab)

    controller_name = controller.controller_name.to_sym
    action_name = controller.action_name.to_sym
    #@@nav_menu[:primary]
    # if tab has same name as controller, then set that tab as current

    if (controller_name == tab)
      return true
    elsif controller_name == :cladename && :my_submission == tab
      return true   
    elsif !current_user.nil?
      if current_user.role == 1
        return true if (controller_name == :sessions || controller_name == :users)  && :admin == tab
      else
        return true if (controller_name == :sessions || controller_name == :users) && :my_submission == tab
      end    
    end
  end

  def generate_subtabs
    # show subnavigation if current tab is selected
      tab = @current_tab

      if (tab && @@nav_menu[:primary][tab][:subnav])
        result_str = '<ul id="secondary">'
        @@nav_menu[:primary][tab][:subnav].each { |subtab|
          # currently selected subtab
          if controller_name == "my_submission" && controller.action_name.to_s == subtab.to_s            
            result_str << "<li class='top_subtab current'>#{link_to "#{@@nav_menu[:secondary][subtab][:title]}",   eval(@@nav_menu[:secondary][subtab][:path])}</li>"
            @sub_tab = subtab
          elsif controller_name == "search" && controller.action_name.to_s == subtab.to_s
            result_str << "<li class='top_subtab current'>#{link_to "#{@@nav_menu[:secondary][subtab][:title]}",   eval(@@nav_menu[:secondary][subtab][:path])}</li>"
            @sub_tab = subtab
          elsif controller_name == subtab.to_s
            result_str << "<li class='top_subtab current'>#{link_to "#{@@nav_menu[:secondary][subtab][:title]}",   eval(@@nav_menu[:secondary][subtab][:path])}</li>"
            @sub_tab = subtab
       
          elsif tab == :search && (controller.action_name == "display_species" or controller.action_name == "display_specimen" or controller.action_name == "display_apomorphy" or controller.action_name == "display_preexisting" or controller.action_name == "display_cladename")
            result_str = "<ul id='secondary'>"
            if controller.action_name.to_s == "display_species"
              result_str << "<li class='top_subtab current'>#{link_to "Species",   display_species_search_path(params[:id])}</li>"
            elsif controller.action_name.to_s == "display_specimen"
               result_str << "<li class='top_subtab current'>#{link_to "Specimen",   display_specimen_search_path(params[:id])}</li>"
            elsif controller.action_name.to_s == "display_apomorphy"
              result_str << "<li class='top_subtab current'>#{link_to "Apomorphy",  display_apomorphy_search_path(params[:id])}</li>"
            elsif controller.action_name.to_s == "display_preexisting"
              result_str << "<li class='top_subtab current'>#{link_to "Pre-existing Name",  display_preexisting_search_path(params[:id])}</li>"
            elsif controller.action_name.to_s == "display_cladename"
              result_str << "<li id='l1' class='top_tab1 current' onclick=tabstatus('l1','3');> <span>Cladename</span></li>"
              result_str << "<li id='l2' class='top_tab1 active' onclick=tabstatus('l2','1');> <span>Internal Specifiers</span></li>"
              result_str << "<li id='l3' class='top_tab1 active' onclick=tabstatus('l3','2');> <span>External Specifiers</span></li>"
              result_str << "<li id='l4' class='top_tab1 active' onclick=tabstatus('l4','4');> <span>Apomorphies</span></li>"
            end
            result_str << "</ul>"
          else
            result_str << "<li class='top_subtab active'>#{link_to raw("<span>#{@@nav_menu[:secondary][subtab][:title]}</span>"), eval(@@nav_menu[:secondary][subtab][:path])}</li>"
          end
        }
        result_str << "</ul>"
      end
  end

    def generate_sub_subtabs
    # show subnavigation if current tab is selected

      tab = @current_tab
      subtab =  @sub_tab


      if (tab && subtab && @@nav_menu[:primary][tab][:subnav] && @@nav_menu[:secondary][subtab][:subnav])
        result_str = "<div id='submain'> <ul id='teritiary'>"
        @@nav_menu[:secondary][subtab][:subnav].each { |sub_subtab|
          # currently selected subtab
          
          if controller_name == "cladename"
            
                if controller.action_name.to_sym == sub_subtab || (sub_subtab == :cladename && (controller.action_name == "edit" || controller.action_name == "new" || controller.action_name == "save"))
                      result_str << "<li class='top_sec_subtab current'>#{link_to "#{@@nav_menu[:teritiary][sub_subtab][:title]}",''}</li>"
                else
                  if params[:id].nil?
                    result_str << "<li class='top_sec_subtab inactive'><span >#{@@nav_menu[:teritiary][sub_subtab][:title]}</span></li>"
                    
                  else
                    result_str << "<li class='top_sec_subtab active'><a href='"+eval(@@nav_menu[:teritiary][sub_subtab][:path])+"' Onclick='  if(change_status == 1){var where_to= confirm(\"Unsaved Data will be Lost. Are you sure you want to Continue ?\");if(where_to){return true}else{return false}}'>"+@@nav_menu[:teritiary][sub_subtab][:title]+"</a>"
    
                  end
                end
              
          elsif controller_name == "my_submission" && controller.action_name.to_s == sub_subtab.to_s
            
            result_str << "<li class='top_sec_subtab current'>#{link_to "#{@@nav_menu[:teritiary][sub_subtab][:title]}",''}</li>"
          elsif  @@librarylist[controller_name.to_sym] && sub_subtab == controller_name.to_sym


          else
            
            result_str << "<li class='top_sec_subtab active'>#{link_to "#{@@nav_menu[:teritiary][sub_subtab][:title]}", eval(@@nav_menu[:teritiary][sub_subtab][:path])}</li>"

          end

        }
        result_str << "</ul></li> </div>"
      end
  end

   def active_tab?(tab)
    
    #if !current_user.nil?
      return true
    #end
    
  end

  def tab_class?(tab)
    if current_tab?(tab)
      tab_class = 'top_tab current'
      elsif active_tab?(tab)
      tab_class = 'top_tab active'
    else
      tab_class = 'top_tab inactive'
    end
  end
end
