Rails.application.routes.draw do
  get 'companies/new'

  get 'users/new'

  root                      'static_pages#home'
  get   'help'        =>    'static_pages#help'
  get   'about'       =>    'static_pages#about'
  get   'contact'     =>    'static_pages#contact'
  get   'signup'      =>    'static_pages#signup'
  get   'user_signup' =>    'users#new'
  get   'company_signup' => 'companies#new'
  resources :users
  resources :companies

end
