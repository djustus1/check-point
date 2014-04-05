Blog::Application.routes.draw do
  get "welcome/index"
  devise_for :users, :controllers => {:sessions => "sessions", :registrations => "devise/registrations", :omniauth_callbacks => "users/omniauth_callbacks"}
  devise_scope :user do
    post 'approve/:id', to: 'devise/registrations#approve', as: 'approve'
    post 'revoke/:id', to: 'devise/registrations#revoke', as: 'revoke'
    get 'userhome/:id', to: 'users#home', as: 'home'
    get 'usersummary/:id', to: 'users#user_summary', as: 'user_summary'
    get 'managersummary', to: 'users#manager_summary', as: 'manager_summary'
    delete 'delete/users/:id', to: 'users#destroy', as: 'destroy'
    post 'upgrade/:id', to: 'users#upgrade', as: 'upgrade'
  end
  resources :users
  root to: "pois#index"
  resources :comment do
    post 'verify', to: 'comments#verify', as: 'verify'
  end
  resources :images
  resources :pois do
      delete 'delete/images/', to: 'images#destroy', as: 'destroy_image'
    resources :images
    resources :comments

  end

end
