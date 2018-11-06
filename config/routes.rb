Rails.application.routes.draw do
  devise_for :users, :controllers => {:registrations => "registrations", :sessions =>"sessions"}
  mount RailsAdmin::Engine => '/admin', as: 'rails_admin'
  resources :images
  resources :tags
  resources :favorites, except: [:new, :index, :show, :edit, :update]
  resources :comments, except: [:new, :index, :show, :edit, :update]

  get 'uploaded', to: 'images#uploaded'
  get 'trends', to: 'trends#index'
  get '/images/tag/:name', to: 'images#find'

  root 'images#index'
end