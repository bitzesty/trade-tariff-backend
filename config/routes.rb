require 'api_constraints'

TradeTariffBackend::Application.routes.draw do
  get "healthcheck" => "healthcheck#index"

  namespace :api, defaults: {format: 'json'}, path: "/" do
    # How (or even if) API versioning will be implemented is still an open question. We can defer
    # the choice until we need to expose the API to clients which we don't control.
    scope module: :v1, constraints: ApiConstraints.new(version: 1, default: true) do
      resources :sections, only: [:index, :show], constraints: { id: /\d{1,2}/ }
      resources :chapters, only: [:show], constraints: { id: /\d{2}/ }
      resources :headings, only: [:show], constraints: { id: /\d{4}/ }
      resources :commodities, only: [:show], constraints: { id: /\d{10}/ }
      resources :geographical_areas, only: [:countries] do
        collection { get :countries }
      end
      resources :updates, only: [:index]

      post "search" => "search#search", via: :post, as: :search
    end
  end

  root to: 'home#show'

  match '*path', to: 'home#not_found'
end
