Hydranorth::Application.routes.draw do
  
  blacklight_for :catalog
  devise_for :users

  Hydra::BatchEdit.add_routes(self)

  # Administrative URLs
  namespace :admin do
    # Job monitoring
    constraints Sufia::ResqueAdmin do
      mount Resque::Server, at: 'queues'
    end
  end

  mount BrowseEverything::Engine => '/browse'
  mount Hydra::Collections::Engine => '/'
  mount HydraEditor::Engine => '/'

  get 'users/:id/lock_access' => 'users#lock_access', as: 'lock_access_user'
  get 'users/:id/unlock_access' => 'users#unlock_access', as: 'unlock_access_user'

  scope :dashboard do

    get '/files',             controller: 'my/files', action: :index, as: 'dashboard_files'
    get '/files/page/:page',  controller: 'my/files', action: :index
    get '/files/facet/:id',   controller: 'my/files', action: :facet, as: 'dashboard_files_facet'

    get '/all',             controller: 'my/all', action: :index, as: 'dashboard_all'
    get '/all/page/:page',  controller: 'my/all', action: :index
    get '/all/facet/:id',   controller: 'my/all', action: :facet, as: 'dashboard_all_facet'
    
  end

  # This must be the very last route in the file because it has a catch-all route for 404 errors.
  # This behavior seems to show up only in production mode.
  mount Sufia::Engine => '/'
  root to: 'homepage#index'
end
