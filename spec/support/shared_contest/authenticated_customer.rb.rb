RSpec.shared_context 'authenticated customer' do
  let(:token) { Jwt.encode(customer_id: customer.id) }
  let(:headers) do
    {
      'Content-Type' => 'application/json',
      'Accept' => 'application/json',
      'Authorization' => "Bearer #{token}"
    }
  end
end

RSpec.shared_context 'unauthenticated customer' do
  let(:token) { nil }
end
