module Api
  module V1
    class SessionsController < ApplicationController
      def create
        customer = Customer.find_by(email: params[:email])

        if customer&.authenticate(params[:password])
          token = Jwt.encode(customer_id: customer.id)
          render locals: { customer: customer, token: token }, status: :ok
        else
          render_json_error("Invalid email or password", :unauthorized)
        end
      end
    end
  end
end
