# require 'sidekiq/web'
require 'api_constraints'

UKTradeTariff::Application.routes.draw do
  # mount Sidekiq::Web => '/sidekiq'

  namespace :api, defaults: {format: 'json'}, path: "/" do
    scope module: :v1, constraints: ApiConstraints.new(version: 1, default: true) do
      resources :sections, only: [:index, :show], constraints: { id: /\d{1,2}/ }
      resources :chapters, only: [:show], constraints: { id: /\d{2}/ }
      resources :headings, only: [:show], constraints: { id: /\d{4}/ }
      resources :commodities, only: [:show, :update], constraints: { id: /\d{10}/ }

      post "search" => "search#search", via: :post, as: :search
    end
  end

  root to: 'home#show'
end
