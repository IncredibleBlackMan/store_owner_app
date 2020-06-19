# frozen_string_literal: true

Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  resources :users, only: :create do
    collection do
      post 'login'
    end
  end

  resources :products do
    resources :subtype_option_pricing

    resources :subtypes do
      resources :subtype_options
    end
  end
end
