Rails.application.routes.draw do
	devise_for :users, controllers: {
    sessions: 'users/sessions',
    registrations: 'users/registrations'
  }
   
  root "welcome#index"
	
	resources :bgg do
		get :verify_user_account, on: :collection
		get :send_validation, on: :collection
		get :search_items, on: :collection
	end
	
	resources :math_trades, path: 'trades' do
		resources :math_trade_items, path: 'items'
		resources :math_trade_wants, path: 'wants' 
		
		get :retrieve_items, on: :member
		get :wantlist, on: :member, as: :manage_wantlist
		get :confirm_delete, on: :member
		post :save_wantlist, on: :member
	end
end
