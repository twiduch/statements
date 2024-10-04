RSpec.shared_examples 'an unauthorized request' do
  it 'returns an unauthorized status' do
    expect(response).to have_http_status(:unauthorized)
  end

  it 'renders unauthorized message' do
    json_response = JSON.parse(response.body)
    expect(json_response['messages']).to eq([ 'Unauthorized' ])
  end
end
