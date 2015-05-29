Rails.application.routes.draw do
  devise_for :users
  devise_scope :user do
    get 'profile', to: 'profiles/registrations#edit'
    put 'profile', to: 'profiles/registrations#update'
    get 'profile/critical_settings', to: 'profiles/critical_settings#edit'
    put 'profile/critical_settings', to: 'profiles/critical_settings#update'
  end

  resources :projects, except: [:edit, :update, :show, :destroy] do
    concern :commentable do
      resources :comments , only: [:create]
    end
    concern :closeable do
      member do
        put :close
        put :reopen
      end
    end

    concern :favorable do
      resource :likes, only: :update
    end

    scope module: 'projects' do
      resources :search, only: [:index], controller: 'search', as: 'project_searches'
      resource :dashboard
      resources :channels, except: :index do
        resources :messages, only: [:create]
      end
      resources :messages, only: [:update, :destroy]
      resources :issues  , concerns: [:commentable, :closeable]
      resources :sprints , concerns: [:commentable, :closeable]
      resources :polls,    concerns: [:commentable, :closeable] do
        resources :polling_options, only: [:update]
      end
      resources :comments, only: [:update, :destroy], concerns: :favorable
      resources :attachments, concerns: [:commentable, :favorable] do
        get 'download', on: :member
      end
      resources :posts
      resources :snippets
      resource :settings, only: [:edit, :update, :destroy]
      resource :statistic, only: [] do
        get 'users'
        get 'tasks'
        get 'attachments'
      end
      namespace :settings do
        resources :roles
        resources :project_roles, path: :roles
        resources :members
        resources :labels, constraints: {id: /\d+/}
        # rematch ProjectParticipation Model path to project_member_path
        resources :project_participations, path: :members
      end
      get 'suggestions', to: 'suggestions#suggestions'
    end

  end
  get '/projects/:id', to: redirect('/projects/%{id}/dashboard')

  namespace :text do
    put :preview
  end

  resources :notices do
    get :link
    put :read
    put :seal
    put :unseal
    put :check, on: :collection
  end

  resources :users



  scope 'profile', as: 'profile' do
    scope module: :profiles do
      resource :notifications, only: [:show, :update]
    end
  end

  resource :dashboard, controller: "dashboard", only: [:show] do
    member do
      get :events
      get :notices
      get :projects
      get :issues
      get :attachments
      get :precious
    end
  end

  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"
  root 'dashboard#show'

  # Example of regular route:
  #   get 'products/:id' => 'catalog#view'

  # Example of named route that can be invoked with purchase_url(id: product.id)
  #   get 'products/:id/purchase' => 'catalog#purchase', as: :purchase

  # Example resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Example resource route with options:
  #   resources :products do
  #     member do
  #       get 'short'
  #       post 'toggle'
  #     end
  #
  #     collection do
  #       get 'sold'
  #     end
  #   end

  # Example resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Example resource route with more complex sub-resources:
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', on: :collection
  #     end
  #   end

  # Example resource route with concerns:
  #   concern :toggleable do
  #     post 'toggle'
  #   end
  #   resources :posts, concerns: :toggleable
  #   resources :photos, concerns: :toggleable

  # Example resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end
end
