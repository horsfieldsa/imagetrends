Rails.application.routes.draw do
  get 'events/index'
  devise_for :users, :controllers => {:registrations => "registrations", :sessions =>"sessions"}
  mount RailsAdmin::Engine => '/admin', as: 'rails_admin'
  resources :images
  resources :recommendations
  resources :tags
  resources :favorites, except: [:new, :index, :show, :edit, :update]
  resources :comments, except: [:new, :index, :show, :edit, :update]

  get 'activity', to: 'events#index'
  get 'uploaded', to: 'images#uploaded'
  get 'trends', to: 'trends#index'
  get '/images/tag/:name', to: 'images#find'

  get :user_recommendations, controller: :recommendations
  get :useritem_recommendations, controller: :recommendations

  root 'images#index'

  mount ActionCable.server => '/cable'
end