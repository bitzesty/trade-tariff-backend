require 'api_constraints'

UKTradeTariff::Application.routes.draw do
  namespace :api, defaults: {format: 'json'} do
    scope module: :v1, constraints: ApiConstraints.new(version: 1, default: true) do
      resources :sections, only: [:index, :show]
      resources :chapters, only: [:index, :show]
      resources :headings, only: [:index, :show]
      resources :commodities, only: [:index, :show]
    end
  end

  root to: 'home#show'
end
