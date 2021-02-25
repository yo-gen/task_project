Rails.application.routes.draw do
  root 'tasks#index'
  resources :tasks, except: :show
  devise_for :users

  get '/redirect', to: 'google#redirect', as: 'redirect'
  get '/callback', to: 'google#callback', as: 'callback'

  post '/events/:task_id', to: 'google#new_event', as: 'new_event'
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
