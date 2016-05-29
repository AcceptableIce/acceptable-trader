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
		resources :math_trade_items, path: 'items' do
			collection do
				get :show_copy_from_previous_trade
				post :copy_from_previous_trade
			end
		end
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
			get :generate_wantlist, to: "math_trades#show_generate_wantlist"
			get :who_wanted_mine
			
			post :confirm_wants
			post :save_wantlist
			post :save_status
			post :generate_wantlist
			
			patch :upload_results
		end
	end
end
