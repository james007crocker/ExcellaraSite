Rails.application.routes.draw do
  get 'password_resets/new'
  get 'password_resets/edit'

  root                      'static_pages#home'
  get   'volunteer'   =>    'static_pages#volunteer'
  get   'privacypolicy' =>  'static_pages#privacypolicy'
  get   'work'   =>    'static_pages#work'
  get   'jobs'   =>    'static_pages#jobs'
  get   'help'        =>    'static_pages#help'
  get   'how_it_works'  =>    'static_pages#how_it_works'
  get   'about'       =>    'static_pages#about'
  get   'contact'     =>    'static_pages#contact'
  get   'send_message' =>   'static_pages#send_message'
  get   'signup'      =>    'static_pages#signup'
  get   'user_signup' =>    'users#new'
  get   'company_signup' => 'companies#new'
  get   'login'       =>    'sessions#new'
  get   'joblist'     =>    'job_postings#joblist'
  post  'login'       =>    'sessions#create'
  delete 'logout'      =>   'sessions#destroy'
  get 'auth/linkedin/callback', to: 'sessions#create'
  get 'auth/linkedin/failure', to: 'static_pages#home'

  resources :users do
    collection do
      get 'matched_jobs'
      patch 'matched_jobs'
      get 'resume'
      get 'viewprofile'
    end
  end

  resources :companies do
    collection do
      get 'activity'
      get 'viewprofile'
      get 'adminportal'
      get 'adminprofessionals'
      get 'admincompanies'
      get 'adminjobs'
      get 'adminapplications'
    end
  end

  resources :account_activations, only: [:edit]
  resources :password_resets,     only: [:new, :create, :edit, :update]
  resources :job_postings
  resources :applicants do
    member do
      get :send_match_email
    end
  end
end
