require 'api_constraints'

TradeTariffBackend::Application.routes.draw do
  get "healthcheck" => "healthcheck#index"

  namespace :api, defaults: {format: 'json'}, path: "/" do
    # How (or even if) API versioning will be implemented is still an open question. We can defer
    # the choice until we need to expose the API to clients which we don't control.
    scope module: :v1, constraints: ApiConstraints.new(version: 1, default: true) do
      resources :sections, only: [:index, :show], constraints: { id: /\d{1,2}/ } do
        scope module: 'sections', constraints: { section_id: /\d{1,2}/, id: /\d+/ } do
          resource :section_note, only: [:show, :create, :update, :destroy]
          resources :search_references, only: [:show, :index, :destroy, :create, :update]
        end
      end

      resources :chapters, only: [:index, :show], constraints: { id: /\d{2}/ } do
        member {
          get :changes
        }

        scope module: 'chapters', constraints: { chapter_id: /\d{2}/, id: /\d+/ } do
          resource :chapter_note, only: [:show, :create, :update, :destroy]
          resources :search_references, only: [:show, :index, :destroy, :create, :update]
        end
      end

      resources :headings, only: [:show], constraints: { id: /\d{4}/ } do
        member {
          get :changes
        }

        scope module: 'headings', constraints: { heading_id: /\d{4}/, id: /\d+/ } do
          resources :search_references, only: [:show, :index, :destroy, :create, :update]
        end
      end

      resources :commodities, only: [:show], constraints: { id: /\d{10}/ } do
        member {
          get :changes
        }

        scope module: 'commodities', constraints: { commodity_id: /\d{10}/, id: /\d+/ } do
          resources :search_references, only: [:show, :index, :destroy, :create, :update]
        end
      end

      resources :geographical_areas, only: [:countries] do
        collection { get :countries }
      end

      resources :updates, only: [:index] do
        collection { get :latest }
      end

      resources :search_references, only: [:index]

      post "search" => "search#search", via: :post, as: :search

      resources :rollbacks, only: [:create, :index]
      resources :footnotes, only: [:index, :show, :update]
      resources :measure_types, only: [:index, :show, :update]
    end
  end

  root to: 'home#show'

  get '*path', to: 'home#not_found'
end
