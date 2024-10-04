require 'rails_helper'

RSpec.describe Api::V1::SessionsController, type: :request do
  let!(:customer) { create(:customer, password: 'password123', email: 'test@example.com') }
  let(:headers) do
    {
      'Content-Type' => 'application/json',
      'Accept' => 'application/json'
    }
  end
  let(:password) { 'password123' }
  let(:email) { customer.email }
  let(:params) do
    {
      email:,
      password:
    }.to_json
  end

  describe 'POST /api/v1/login' do
    before do
      post '/api/v1/login', params:, headers: headers
    end

    context 'when credentials are valid' do
      it 'returns a JWT token and customer information' do
        expect(response).to have_http_status(:ok)
        expect(JSON.parse(response.body)).to have_key('token')
      end
    end

    context 'when password is invalid' do
      let(:password) { 'wrongpassword' }

      it 'returns an error message and unauthorized status' do
        expect(response).to have_http_status(:unauthorized)
        expect(JSON.parse(response.body)['messages']).to eq([ 'Invalid email or password' ])
      end
    end

    context 'when email does not exist' do
      let(:email) { 'notfound@example.com' }

      it 'returns an error message and unauthorized status' do
        expect(response).to have_http_status(:unauthorized)
        expect(JSON.parse(response.body)['messages']).to eq([ 'Invalid email or password' ])
      end
    end
  end
end
