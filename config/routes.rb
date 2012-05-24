require 'api_constraints'

UKTradeTariff::Application.routes.draw do
  namespace :api, defaults: {format: 'json'}, path: "/" do
    scope module: :v1, constraints: ApiConstraints.new(version: 1, default: true) do
      resources :sections, only: [:index, :show]
      resources :chapters, only: [:show]
      resources :headings, only: [:show]
      resources :commodities, only: [:show]

      post "search" => "search#search", via: :post, as: :search
    end
  end

  root to: 'home#show'
end
