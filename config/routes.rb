Rails.application.routes.draw do
  
  get 'shipment/add_detail'         => 'shipment_maintenance#add_detail'
  get 'shipment/:id/edit_detail/:detail_id'    => 'shipment_maintenance#edit_detail'
  post 'shipment/add_detail'        => 'shipment_maintenance#save_detail' 
  post 'shipment/add_header'        => 'shipment_maintenance#add_header' 
  post 'shipment/:id/update_header' => 'shipment_maintenance#update_header' 
  post 'shipment/:id/update_detail' => 'shipment_maintenance#update_detail' 
  
  get 'configuration/' => 'configuration_maintenance#index'
  put 'configuration/:id' => 'configuration_maintenance#update'
  
  resources :mainmenu,  controller: 'main_menu'

  resources :shipmentreceive, controller: 'shipment_receive'
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
