Rails.application.routes.draw do
  devise_for :users, :controllers => {:registrations => "registrations", :sessions =>"sessions"}
  mount RailsAdmin::Engine => '/admin', as: 'rails_admin'
  resources :sneakers
  resources :tags
  resources :favorites, except: [:new, :index, :show, :edit, :update]

  get 'uploaded', to: 'sneakers#uploaded'
  get 'trends', to: 'trends#index'
  get 'unapproved', to: 'sneakers#unapproved'
  get '/sneakers/tag/:name', to: 'sneakers#find'

  root 'sneakers#index'
end