Rails.application.routes.draw do
  
  namespace :api do
    namespace :v1 do
      resources :users, only: [:create]
      resources :puzzles, only: [:create,:index,:show,:update]
      post '/login', to: 'auth#create'

      get '/puzzle_proxy/wsj/:date', to: 'puzzle_proxy#wsj'
      get '/puzzle_proxy/wapo/:date', to: 'puzzle_proxy#wapo'
      get '/puzzle_proxy/ps/:date', to: 'puzzle_proxy#ps'
    end
  end
  
end
