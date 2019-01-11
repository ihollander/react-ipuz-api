Rails.application.routes.draw do
  
  namespace :api do
    namespace :v1 do
      get '/puzzle_proxy/wsj/:date', to: 'puzzle_proxy#wsj'
      get '/puzzle_proxy/wapo/:date', to: 'puzzle_proxy#wapo'
    end
  end
  
end
