require 'api_constraints'

UKTradeTariff::Application.routes.draw do
  namespace :api, defaults: {format: 'json'}, path: "/" do
    scope module: :v1, constraints: ApiConstraints.new(version: 1, default: true) do
      resources :sections, only: [:index, :show], constraints: { id: /\d{1,2}/ }
      resources :chapters, only: [:show], constraints: { id: /\d{2}/ }
      resources :measures, only: [:create, :update, :delete]

      post "search" => "search#search", via: :post, as: :search
    end
  end

  match "/stats", to: 'home#stats'

  root to: 'home#show'

  match '*path', to: 'home#not_found'
end
