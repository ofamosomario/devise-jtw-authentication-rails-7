# frozen_string_literal: true

Rails.application.routes.draw do
  # Devise routes for user authentication
  devise_for :users, path: '', path_names:
  {
    sign_in: 'login',
    sign_out: 'logout',
    registration: 'signup'
  }, controllers:
  {
    sessions: 'api/v1/authentication/sessions',
    registrations: 'api/v1/users/registrations'
  }

  get 'up' => 'rails/health#show', as: :rails_health_check
end
