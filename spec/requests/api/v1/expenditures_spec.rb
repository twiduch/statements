require 'rails_helper'

RSpec.describe Api::V1::ExpendituresController, type: :request do
  let(:customer) { create(:customer) }
  let(:ie_statement) { create(:ie_statement, customer: customer) }

  describe 'POST /api/v1/ie_statements/:ie_statement_id/expenditures' do
    let(:valid_params) do
      {
        expenditure: {
          category: 'Mortage',
          amount: 80000
        }
      }
    end
    let(:invalid_params) do
      {
        expenditure: {
          category: '',
          amount: ''
        }
      }
    end

    before do
      post "/api/v1/ie_statements/#{ie_statement.id}/expenditures", params:, headers: headers, as: :json
    end

    context 'when authenticated' do
      let(:params) { valid_params }
      include_context 'authenticated customer'

      context 'with valid parameters' do
        it 'returns status :created' do
          expect(response).to have_http_status(:created)
        end

        it 'creates a new expenditure' do
          expect {
            post "/api/v1/ie_statements/#{ie_statement.id}/expenditures", params:, headers: headers, as: :json
          }.to change(Expenditure, :count).by(1)
        end

        it 'creates proper response' do
          body = JSON.parse(response.body)
          expect(body['category']).to eq('Mortage')
          expect(body['amount']).to eq(80000)
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
            post "/api/v1/ie_statements/#{ie_statement.id}/expenditures", params:, headers: headers, as: :json
          }.not_to change(IeStatement, :count)
        end
      end
    end

    context 'when not authenticated' do
      let(:params) { valid_params }
      it_behaves_like 'an unauthorized request'
    end
  end

  describe 'GET /api/v1/expenditures/:id' do
    let(:expenditure) { create(:expenditure) }
    let!(:ie_statement) { create(:ie_statement, customer:, expenditures: [expenditure]) }

    before do
      get "/api/v1/expenditures/#{expenditure.id}", headers: headers
    end

    context 'when authenticated' do
      include_context 'authenticated customer'

      context 'when expenditure exists for a user' do
        it 'returns status :ok' do
          expect(response).to have_http_status(:ok)
        end

        it 'renders the correct ie_statement' do
          body = JSON.parse(response.body)
          expect(body['id']).to eq(expenditure.id)
          expect(body['amount']).to eq(expenditure.amount)
        end
      end

      context 'when expenditure for different user' do
        let(:customer2) { create(:customer) }
        let!(:ie_statement) { create(:ie_statement, customer: customer2, expenditures: [expenditure]) }

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
