Rails.application.routes.draw do
  resources :projects, except: [:show] do
    concern :commentable do
      resources :comments , only: [:create]
    end

    scope module: 'projects' do
      resource :dashboard
      resources :members
      resources :issues , concerns: :commentable do
        member do
          put :close
          put :reopen
        end
      end
      resources :comments ,only: [:update, :destroy]
      resources :attachments
      resources :posts, as: 'attachment_posts'
      resources :snippets, as: 'attachment_snippets'
      resources :labels, constraints: {id: /\d+/}
    end

    # rematch ProjectParticipation Model path to project_member_path
    resources :project_participations, as: :participations, path: :members
  end
  get '/projects/:id', to: redirect('/projects/%{id}/dashboard')

  namespace :text do
    put :preview
  end

  resources :profiles

  devise_for :users
  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"
  root 'welcome#index'

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
