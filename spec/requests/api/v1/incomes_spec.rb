require 'rails_helper'

RSpec.describe Api::V1::IncomesController, type: :request do
  let(:customer) { create(:customer) }
  let(:ie_statement) { create(:ie_statement, customer: customer) }

  describe 'POST /api/v1/ie_statements/:ie_statement_id/incomes' do
    let(:valid_params) do
      {
        income: {
          category: 'Salary',
          amount: 300000
        }
      }
    end
    let(:invalid_params) do
      {
        income: {
          category: '',
          amount: ''
        }
      }
    end

    before do
      post "/api/v1/ie_statements/#{ie_statement.id}/incomes", params:, headers: headers, as: :json
    end

    context 'when authenticated' do
      let(:params) { valid_params }
      include_context 'authenticated customer'

      context 'with valid parameters' do
        it 'returns status :created' do
          expect(response).to have_http_status(:created)
        end

        it 'creates a new income' do
          expect {
            post "/api/v1/ie_statements/#{ie_statement.id}/incomes", params:, headers: headers, as: :json
          }.to change(Income, :count).by(1)
        end

        it 'creates proper response' do
          body = JSON.parse(response.body)
          expect(body['category']).to eq('Salary')
          expect(body['amount']).to eq(300000)
        end

        context 'when not own statement' do
          let(:ie_statement) { create(:ie_statement) }

          it 'returns :not_found' do
            expect(response).to have_http_status(:not_found)
          end
        end
      end

      context 'with invalid parameters' do
        let(:params) { invalid_params }

        it 'returns status :unprocessable_entity' do
          expect(response).to have_http_status(:unprocessable_entity)
        end

        it 'returns error messages' do
          expect(JSON.parse(response.body)['messages']).to include("Category can't be blank")
          expect(JSON.parse(response.body)['messages']).to include("Amount can't be blank")
        end

        it 'does not create a new statement' do
          expect {
            post "/api/v1/ie_statements/#{ie_statement.id}/incomes", params:, headers: headers, as: :json
          }.not_to change(IeStatement, :count)
        end
      end
    end

    context 'when not authenticated' do
      let(:params) { valid_params }
      it_behaves_like 'an unauthorized request'
    end
  end

  describe 'GET /api/v1/incomes/:id' do
    let(:income) { create(:income) }
    let!(:ie_statement) { create(:ie_statement, customer:, incomes: [income]) }

    before do
      get "/api/v1/incomes/#{income.id}", headers: headers
    end

    context 'when authenticated' do
      include_context 'authenticated customer'

      context 'when income exists for a user' do
        it 'returns status :ok' do
          expect(response).to have_http_status(:ok)
        end

        it 'renders the correct ie_statement' do
          body = JSON.parse(response.body)
          expect(body['id']).to eq(income.id)
          expect(body['amount']).to eq(income.amount)
        end
      end

      context 'when income for different user' do
        let(:customer2) { create(:customer) }
        let!(:ie_statement) { create(:ie_statement, customer: customer2, incomes: [income]) }

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
end
