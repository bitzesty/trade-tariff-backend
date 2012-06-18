require 'api_constraints'

UKTradeTariff::Application.routes.draw do
  namespace :api, defaults: {format: 'json'}, path: "/" do
    scope module: :v1, constraints: ApiConstraints.new(version: 1, default: true) do
      resources :sections, only: [:index, :show], constraints: { id: /\d{1,2}/ }
      resources :chapters, only: [:show], constraints: { id: /\d{2}/ }
      resources :headings, only: [:show], constraints: { id: /\d{4}/ } do
        resources :import_measures, only: [:index]
        resources :export_measures, only: [:index]
      end
      resources :commodities, only: [:show, :update], constraints: { id: /\d{12}/ } do
        resources :import_measures, only: [:index]
        resources :export_measures, only: [:index]
      end

      resources :measures, only: [:create, :update, :delete]

      post "search" => "search#search", via: :post, as: :search
    end
  end

  match "/stats", to: "home#stats"
  root to: 'home#show'
end
