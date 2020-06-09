Regnum::Application.routes.draw do
  
  match '/' => 'search#index', via: :get
  match '/logout' => 'accounts#logout', :as => :logout, via: [:get, :post]
  match '/login' => 'accounts#login', :as => :login, via: :get
  match '/authenticate' => 'accounts#authenticate', :as => :authenticate, via: :post
  match '/signup' => 'accounts#new', :as => :signup, via: :get

  match '/mysubmission_show' => 'my_submission#show', :as => :mysubmission, via: :get
  #name conflict:
  # match '/admin_show' => 'admin#show', :as => :admin, via: :get
  match '/new_submission' => 'my_submission#new', :as => :new_submission, via: :get
  match '/create_submission' => 'my_submission#new', :as => :create_submission, via: :get
  #don't see this anywhere
  # match '/accepted' => 'my_submission#accepted', :as => :accepted
  match '/cladename' => 'my_submission#cladename', :as => :cladename, via: [:get, :post]
  match '/save' => 'my_submission#save', :as => :save, via: :post
  match '/create' => 'my_submission#create', as: 'create', via: :post
  
  match '/faq' => 'application#faq', :as => :faq, via: :get
  match '/help' => 'accounts#help', :as => :help, via: :get

  match '/search' => 'search#index', :as => :search, via: :get
  match '/search/:id' => 'search#show', :as => :show, via: :get
  match '/search_res' => 'search#search_res', :as => :search_res, via: :get

  match '/save_submission' => 'my_submission#save_submission', as: :save_submission, via: [:post,:put]
  match '/name/:id' => 'cladename#find_name', :as => :name, via: :get

  match '/my_submission' => 'my_submission#index', :as => :my_submission, via: :get
  match '/my_submission/new' => 'my_submission#new', :as => :new, via: :get
  match '/my_submission/check_name' => 'my_submission#check_name', :as => :check_name, via: :get
  match '/my_submission/template' => 'my_submission#template', :as => :template, via: :get
  match '/my_submission/add_attachment' => 'my_submission#add_attachment', :as => :add_attachment, via: :post
  match '/my_submission/view_attachment/:id' => 'my_submission#view_attachment', :as => :view_attachment, via: :get
  match '/my_submission/remove_attachment/:id' => 'my_submission#remove_attachment', :as => :remove_attachment, via: :get
  match '/my_submission/delete/:id' => 'my_submission#delete', :as => :delete, via: :delete
  #this one comes last so my_submission method calls can pass
  match '/my_submission/:id' => 'my_submission#show', :as => :show_my_submission, via: :get
  match '/templates/load' => 'templates#load', :as => :load_template, via: :get
  #
  match '/admin' => 'admin#index', :as => :admin, via: :get
  match '/admin/add_user' => 'admin#add_user', :as => :add_user_admin, via: :get
  #
  # match '/admin/users/:id' => 'admin#index', via: :get
  match '/admin/users/:id' => 'admin#edit_user', via: [:get,:put,:delete]
  match '/admin/update_user/:id' => 'admin#update_user', :as => :update_user, via: :patch
  #
  match '/phenotypes' => 'phenotypes#index', :as => :phenotypes, via: :get
  match '/phenotypes/create' => 'phenotypes#create', via: :post
  match '/phenotypes/import_ontologies' => 'phenotypes#import_ontologies', via: :post
  #match '/phenotypes/new/:state_id' => 'phenotypes#new'
  match '/phenotypes/new' => 'phenotypes#new', via: :get
  match '/phenotypes/get_form_fields' => 'phenotypes#get_form_fields', via: :get

  match '/characters/new' => 'phenotypes#new_character', via: :get
  match '/characters/create_character' => 'phenotypes#create_character', via: :post
  match '/characters/destroy_character' => 'phenotypes#destroy_character', via: :post
  match '/characters/destroy_state' => 'phenotypes#destroy_state', via: :post
  match '/characters/destroy_phenotype' => 'phenotypes#destroy_phenotype', via: :post
  match '/characters/:character_id/states/new' => 'phenotypes#new_state', via: :get
  match '/characters/:character_id/states' => 'phenotypes#create_state' , :via => [:post]

  match '/ontologies/auto_complete_terms' => 'ontologies#auto_complete_terms', via: :get
  resources :accounts
  resources :submissions do
    collection do
      get :export
      get :export_json
      get :crown_specifiers
    end
  end

  #match '/:controller(/:action(/:id))'
end
