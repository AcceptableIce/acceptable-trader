Rails.application.routes.draw do
	devise_for :users, controllers: {
    sessions: 'users/sessions',
    registrations: 'users/registrations'
  }
   
  root "welcome#index"
  
  get "rules" => "welcome#rules", as: :rules
  get "about" => "welcome#about", as: :about
  
  get "settings" => "users/settings#index", as: :settings
	
	resources :bgg do
		get :verify_user_account, on: :collection
		get :send_validation, on: :collection
		get :search_items, on: :collection
	end
	
	resources :math_trades, path: 'trades' do
		resources :math_trade_items, path: 'items'
		resources :math_trade_wants, path: 'wants'
		resources :want_groups, path: 'groups'
		
		member do		
			get :retrieve_items
			get :wantlist, as: :manage_wantlist
			get :confirm_delete
			get :status
			get :upload
			get :results
			get :raw_results
			get :generate_wantlist
			
			post :save_wantlist
			post :save_status
			patch :upload_results
		end
	end
end
