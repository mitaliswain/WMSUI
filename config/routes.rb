Rails.application.routes.draw do

  namespace :main do
    get '', action: 'index'
  end

  namespace :shipment_maintenance do
    get '' ,  action: 'index'
    get  ':id', action: 'show'
    get  ':id/detail/:detail_id', action: 'show_detail'

    post 'add_detail', action: 'add_detail'
    post 'add_header', action: 'add_header'

    post ':id/update_header',  action: 'update_header'
    post ':id/update_detail',  action: 'update_detail'

    post ':id', action: 'show'

    post ':shipment_nbr/receive',  action: 'receive'
    post ':to_validate/validate',  action: 'validate'

  end


  namespace :case_maintenance do
    get '' ,  action: 'index'
    get  ':id', action: 'show'
    get  ':id/detail/:detail_id', action: 'show'


    post 'add_header', action: 'add_header'
    post 'add_detail', action: 'add_detail'
    post ':id', action: 'show'

    post ':id/update_header', action:'update_header'
    post ':id/update_detail', action:'update_detail'

  end

  namespace :configuration_maintenance do
    get '', action: 'index'
    get  ':id', action: 'show'
    post ':id', action: 'update'
    post '', action: 'create'
  end


  namespace :item_master_maintenance do
    get '', action: 'index'
    get  ':id', action: 'show'
    post ':id', action: 'update'
    post '', action: 'create'
  end

  namespace :login do
    get '', action: 'index'
    get  ':id', action: 'show'
    post ':id', action: 'update'
    post '', action: 'create'
  end

  resources :shipment, controller: 'shipment_maintenance'

  
  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"
  # root 'welcome#index'

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
