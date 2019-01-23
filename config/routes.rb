Rails.application.routes.draw do
  
  namespace :api do
    namespace :v1 do
      resources :users, only: [:create]
      patch '/profile', to: 'users#profile'
      post '/login', to: 'auth#create'

      resources :games, only: [:show, :create, :index, :update, :destroy] do
        resources :messages, only: [:index, :create]
        member do
          patch 'join'
          patch 'update_cell'
          patch 'update_position'
          patch 'check_answer'
          patch 'reveal_answer'
          patch 'pause'
          patch 'unpause'
          patch 'mark_active'
          patch 'mark_inactive'
        end
        collection do
          patch 'leave_all'
        end
      end

      get '/puzzle_proxy/today', to: 'puzzle_proxy#today'
      get '/puzzle_proxy/wsj/:date', to: 'puzzle_proxy#wsj'
      get '/puzzle_proxy/wapo/:date', to: 'puzzle_proxy#wapo'
      get '/puzzle_proxy/ps/:date', to: 'puzzle_proxy#ps'

    end
  end
  
  mount ActionCable.server => '/cable'
end
