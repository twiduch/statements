require 'rails_helper'

RSpec.describe Api::V1::IeStatementsController, type: :request do
  let(:customer) { create(:customer) }
  let(:valid_params) do
    {
      ie_statement: {
        name: 'Budget1',
        incomes_attributes: [ { category: 'Salary', amount: 300000 } ],
        expenditures_attributes: [ { category: 'Rent', amount: 100000 }, { category: 'Travel', amount: 15000 } ]
      }
    }
  end

  let(:invalid_params) do
    {
      ie_statement: {
        name: '',
        incomes_attributes: [ { category: '', amount: 0 } ],
        expenditures_attributes: [ { category: '', amount: 0 } ]
      }
    }
  end

  describe 'POST /api/v1/customers/:customer_id/ie_statements' do
    before do
      post "/api/v1/customers/#{customer.id}/ie_statements", params:, headers: headers, as: :json
    end

    context 'when authenticated' do
      let(:params) { valid_params }
      include_context 'authenticated customer'

      context 'with valid parameters' do
        it 'returns status :created' do
          expect(response).to have_http_status(:created)
        end

        it 'creates a new statement' do
          expect {
            post "/api/v1/customers/#{customer.id}/ie_statements", params:, headers: headers, as: :json
          }.to change(IeStatement, :count).by(1)
        end

        it 'creates proper response' do
          body = JSON.parse(response.body)
          expect(body['name']).to eq('Budget1')
          expect(body['incomes'].first['category']).to eq('Salary')
          expect(body['expenditures'].first['category']).to eq('Rent')
        end
      end

      context 'with invalid parameters' do
        let(:params) { invalid_params }

        it 'returns status :unprocessable_entity' do
          expect(response).to have_http_status(:unprocessable_entity)
        end

        it 'returns error messages' do
          expect(JSON.parse(response.body)['messages']).to include("Name can't be blank")
          expect(JSON.parse(response.body)['messages']).to include("Incomes category can't be blank")
        end

        it 'does not create a new statement' do
          expect {
            post "/api/v1/customers/#{customer.id}/ie_statements", params:, headers: headers, as: :json
          }.not_to change(IeStatement, :count)
        end
      end
    end

    context 'when not authenticated' do
      let(:params) { valid_params }
      it_behaves_like 'an unauthorized request'
    end
  end
end
