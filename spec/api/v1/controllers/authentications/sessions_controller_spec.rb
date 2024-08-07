# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Api::V1::Authentication::SessionsController, type: :controller do
  include Devise::Test::ControllerHelpers

  let!(:user) { User.create(email: 'valid_user@gmail.com', password: '123test', password_confirmation: '123test') }

  before do
    @request.env['devise.mapping'] = Devise.mappings[:user]
  end

  describe 'POST #create' do
    context 'when login is successful' do
      it 'returns a successful response with user data' do
        post :create, params: { user: { email: 'valid_user@gmail.com', password: '123test' } }, as: :json

        expect(response).to have_http_status(:ok)
        expect(JSON.parse(response.body)['status']['message']).to eq('Logged in successfully.')
        expect(JSON.parse(response.body)['data']).to be_present
      end
    end

    context 'when login fails' do
      it 'returns an unauthorized response' do
        post :create, params: { user: { email: 'valid_user@gmail.com', password: 'wrongpassword' } }, as: :json

        expect(response).to have_http_status(:unauthorized)
        expect(JSON.parse(response.body)['error']).to eq('Invalid Email or password.')
      end
    end
  end

  describe 'DELETE #destroy' do
    before do
      sign_in user
    end

    context 'when logout is successful' do
      it 'returns a successful response' do
        delete :destroy, as: :json

        expect(response).to have_http_status(:ok)
        expect(JSON.parse(response.body)['message']).to eq('logged out successfully')
      end
    end

    context 'when there is no active session' do
      it 'returns an unauthorized response' do
        sign_out user

        delete :destroy, as: :json

        expect(response).to have_http_status(:unauthorized)
        expect(JSON.parse(response.body)['message']).to eq('Could not find an active session.')
      end
    end
  end
end
