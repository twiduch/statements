module ControllerHelpers
  def sign_in(customer)
    let(:token) { Jwt.encode(customer_id: customer.id) }
    let(:headers) do
      {
        'Authorization' => "Bearer #{token}"
      }
    end
  end
end
