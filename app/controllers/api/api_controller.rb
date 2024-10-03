class Api::ApiController < ApplicationController
  before_action :authenticate_user!

  private

  def authenticate_user!
    header = request.headers["Authorization"]
    token = header&.split(" ")&.last

    if token
      decoded_token = Jwt.decode(token)
      @current_user = Customer.find_by(id: decoded_token[:customer_id]) if decoded_token
    end

    render_json_error("Unauthorized", :unauthorized) unless current_user
  end

  def current_user
    @current_user
  end

  def render_json_error(msg, status)
    render json: { status: "error", message: msg }, status:
  end
end
