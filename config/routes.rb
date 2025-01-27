Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html
  post 'users/register',            to: 'users#register'
  post 'users/login',               to: 'users#login'
  get 'users/restricted',           to: 'users#restricted'
  post 'users/change_password',     to: 'users#change_password'
  delete 'users',                   to: 'users#destroy_user'
  delete 'users/logout',            to: 'users#logout'

  resources :password_resets, only: [:create, :update]

  post 'token', to: 'jwt_tokens#regenerate_token'

  get 'email_confirmations/:token', to: 'email_confirmations#confirm', as: :email_confirmations_confirm

end
