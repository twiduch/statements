require 'rails_helper'

RSpec.describe Api::V1::CustomersController, type: :request do
  let!(:customer) { create(:customer, password: 'password123', email: 'test@example.com') }
  let(:headers) { nil }

  describe 'GET /api/v1/customers/current' do
    before do
      get '/api/v1/customers/current', headers: headers
    end

    context 'when authenticated' do
      include_context 'authenticated customer'

      it 'returns status ok' do
        expect(response).to have_http_status(:ok)
      end

      it 'returns the current customer details' do
        json_response = JSON.parse(response.body)
        expect(json_response['id']).to eq(customer.id)
        expect(json_response['email']).to eq(customer.email)
        expect(json_response['name']).to eq(customer.name)
      end
    end

    context 'when not authenticated' do
      it_behaves_like 'an unauthorized request'
    end
  end
end
