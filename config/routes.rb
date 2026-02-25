Rails.application.routes.draw do
  get "up" => "rails/health#show", as: :rails_health_check

  root "pages#home"

  get "how-it-works", to: "pages#how_it_works"
  get "what-we-replace", to: "pages#what_we_replace"
  get "faq", to: "pages#faq"
  get "pricing", to: "pages#pricing"
  get "case-studies", to: "pages#case_studies"
  get "about", to: "pages#about"
  get "contact", to: "pages#contact"
  get "privacy", to: "pages#privacy"
  get "terms", to: "pages#terms"
  get "solutions/:slug", to: "landing_pages#show", as: :solution

  resources :leads, only: :create

  namespace :admin do
    root to: "leads#index"

    resources :leads, only: %i[index show] do
      collection do
        get :export
      end
    end
    resources :visits, only: :index
    resources :landing_pages, except: :show
    resource :settings, only: %i[edit update]
  end

  get "sitemap.xml", to: "sitemaps#show", defaults: { format: :xml }
end
