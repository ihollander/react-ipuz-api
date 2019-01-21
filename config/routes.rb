Rails.application.routes.draw do
  
  namespace :api do
    namespace :v1 do
      resources :users, only: [:create]
      resources :puzzles, only: [:create,:index,:show,:update] do
        resources :shared_games, only: [:create]
      end
      resources :shared_games, only: [:show]  do
        post '/update_cell', to: 'shared_games#update_cell'
        post '/update_position', to: 'shared_games#update_position'
      end

      post '/login', to: 'auth#create'

      get '/puzzle_proxy/today', to: 'puzzle_proxy#today'
      get '/puzzle_proxy/wsj/:date', to: 'puzzle_proxy#wsj'
      get '/puzzle_proxy/wapo/:date', to: 'puzzle_proxy#wapo'
      get '/puzzle_proxy/ps/:date', to: 'puzzle_proxy#ps'

    end
  end
  
  mount ActionCable.server => '/cable'
end
