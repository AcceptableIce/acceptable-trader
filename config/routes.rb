Rails.application.routes.draw do
	devise_for :users, controllers: {
    sessions: 'users/sessions',
    registrations: 'users/registrations'
  }
   
  root "welcome#index"
	
	resources :bgg do
		get :verify_user_account, on: :collection
	end
	
	resources :math_trades, path: 'trades'
end
