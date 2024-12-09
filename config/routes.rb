Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html
  post 'register',  to: 'users#register'
  post 'login',     to: 'users#login'
  get 'restricted', to: 'users#restricted'
  post 'forgot',    to: 'users#forgot'
end
