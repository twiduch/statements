require 'rails_helper'

RSpec.describe Api::V1::IeStatementsController, type: :request do
  let(:customer) { create(:customer) }

  describe 'POST /api/v1/customers/:customer_id/ie_statements' do
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

        it 'calculates rating' do
          body = JSON.parse(response.body)
          expect(body['rating']).to eq('C')
        end

        it 'calculates disposable_income' do
          body = JSON.parse(response.body)
          expect(body['disposable_income']).to eq(185000)
        end

        context 'when trying to create ie_statement for different user' do
          let(:customer2) { create(:customer) }

          it 'returns :forbidden' do
            post "/api/v1/customers/#{customer2.id}/ie_statements", params:, headers: headers, as: :json

            expect(response).to have_http_status(:forbidden)
          end
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

  describe 'GET /api/v1/ie_statements/:id' do
    let(:income) { create(:income) }
    let(:ie_statement) { create(:ie_statement, customer:, incomes: [ income ]) }

    before do
      get "/api/v1/ie_statements/#{ie_statement.id}", headers: headers
    end

    context 'when authenticated' do
      include_context 'authenticated customer'

      context 'when statement exists for a user' do
        it 'returns status :ok' do
          expect(response).to have_http_status(:ok)
        end

        it 'renders the correct ie_statement' do
          body = JSON.parse(response.body)
          expect(body['id']).to eq(ie_statement.id)
          expect(body['name']).to eq(ie_statement.name)
        end

        it 'includes incomes' do
          body = JSON.parse(response.body)
          first_income = body['incomes'].first
          expect(first_income['id']).to eq(income.id)
          expect(first_income['amount']).to eq(income.amount)
        end

        it 'includes empty expenditures' do
          body = JSON.parse(response.body)
          expect(body['expenditures']).to eq([])
        end
      end

      context 'when the ie_statement for different user' do
        let(:customer2) { create(:customer) }
        let(:ie_statement) { create(:ie_statement, customer: customer2) }

        it 'returns status :not_found' do
          expect(response).to have_http_status(:not_found)
        end

        it 'returns an error message' do
          expect(JSON.parse(response.body)['messages']).to include('Record not found')
        end
      end
    end

    context 'when not authenticated' do
      it_behaves_like 'an unauthorized request'
    end
  end

  describe 'GET /api/v1/ie_statements' do
    let(:customer2) { create(:customer) }
    let!(:ie_statement1) { create(:ie_statement, customer:) }
    let!(:ie_statement2) { create(:ie_statement, customer: customer2) }

    before do
      get "/api/v1/ie_statements", headers: headers
    end

    context 'when authenticated' do
      include_context 'authenticated customer'


      it 'returns status :ok' do
        expect(response).to have_http_status(:ok)
      end

      it 'shows ie_statement for authenticated uuser' do
        body = JSON.parse(response.body)
        expect(body.count).to eq(1)
        expect(body.first["id"]).to eq(ie_statement1.id)
      end
    end

    context 'when not authenticated' do
      it_behaves_like 'an unauthorized request'
    end
  end
end
