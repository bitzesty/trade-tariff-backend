require 'api_constraints'

Rails.application.routes.draw do
  get "healthcheck" => "healthcheck#index"

  namespace :api, defaults: { format: 'json' }, path: "/admin" do
    scope module: :admin do
      resources :sections, only: [:index, :show], constraints: { id: /\d{1,2}/ } do
        scope module: 'sections', constraints: { section_id: /\d{1,2}/, id: /\d+/ } do
          resource :section_note, only: [:show, :create, :update, :destroy]
          resources :search_references, only: [:show, :index, :destroy, :create, :update]
        end
      end

      resources :updates, only: [:index]
      resources :rollbacks, only: [:create, :index]
      resources :footnotes, only: [:index, :show, :update]
      resources :measure_types, only: [:index, :show, :update]
      resources :search_references, only: [:index]
      
      resources :chapters, only: [:index, :show], constraints: { id: /\d{2}/ } do
        scope module: 'chapters', constraints: { chapter_id: /\d{2}/, id: /\d+/ } do
          resource :chapter_note, only: [:show, :create, :update, :destroy]
          resources :search_references, only: [:show, :index, :destroy, :create, :update]
        end
      end

      resources :headings, only: [:show], constraints: { id: /\d{4}/ } do
        scope module: 'headings', constraints: { heading_id: /\d{4}/, id: /\d+/ } do
          resources :search_references, only: [:show, :index, :destroy, :create, :update]
        end
      end

      resources :commodities, only: [:show], constraints: { id: /\d{10}/ } do
        scope module: 'commodities', constraints: { commodity_id: /\d{10}/, id: /\d+/ } do
          resources :search_references, only: [:show, :index, :destroy, :create, :update]
        end
      end
    end
  end

  namespace :api, defaults: {format: 'json'}, path: "/" do
    # How (or even if) API versioning will be implemented is still an open question. We can defer
    # the choice until we need to expose the API to clients which we don't control.

    scope module: :v2, constraints: ApiConstraints.new(version: 2, default: false) do
      resources :sections, only: [:index, :show], constraints: { id: /\d{1,2}/ } do
        collection do
          get :tree
        end
      end

      resources :chapters, only: [:index, :show], constraints: { id: /\d{2}/ } do
        member {
          get :changes
        }
      end

      resources :headings, only: [:show], constraints: { id: /\d{4}/ } do
        member {
          get :changes
        }
      end

      resources :commodities, only: [:show], constraints: { id: /\d{10}/ } do
        member {
          get :changes
        }
      end

      resources :geographical_areas, only: [:index, :countries] do
        collection { get :countries }
      end

      resources :monetary_exchange_rates, only: [:index]

      resources :updates, only: [] do
        collection { get :latest }
      end

      resources :search_references, only: [:index]

      resources :quotas, only: [:search] do
        collection { get :search }
      end

      post "search" => "search#search"
      get "search_suggestions" => "search#suggestions"
      get '/headings/:id/tree' => 'headings#tree'

      get 'goods_nomenclatures/section/:position', to: 'goods_nomenclatures#show_by_section', constraints: { position: /\d{1,2}/ }
      get 'goods_nomenclatures/chapter/:chapter_id', to: 'goods_nomenclatures#show_by_chapter', constraints: { chapter_id: /\d{2}/ }
      get 'goods_nomenclatures/heading/:heading_id', to: 'goods_nomenclatures#show_by_heading', constraints: { heading_id: /\d{4}/ }
    end

    scope module: :v1, constraints: ApiConstraints.new(version: 1, default: true) do
      resources :sections, only: [:index, :show], constraints: { id: /\d{1,2}/ } do
        collection do
          get :tree
        end
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

      resources :commodities, only: [:show], constraints: { id: /\d{10}/, as_of: /.*/ } do
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

      resources :monetary_exchange_rates, only: [:index]

      resources :updates, only: [:index] do
        collection { get :latest }
      end

      resources :search_references, only: [:index]

      post "search" => "search#search"
      get "search_suggestions" => "search#suggestions"
      get '/headings/:id/tree' => 'headings#tree'

      resources :rollbacks, only: [:create, :index]
      resources :footnotes, only: [:index, :show, :update]
      resources :measure_types, only: [:index, :show, :update]
    end
  end

  root to: 'application#nothing'

  get '*path', to: 'application#render_not_found'
end
