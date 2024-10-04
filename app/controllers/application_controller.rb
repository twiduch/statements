class ApplicationController < ActionController::API
  rescue_from ActiveRecord::RecordNotFound do |e|
    render_json_error("Record not found", 404)
  end

  rescue_from AppErrors::NotAuthorizedError do |e|
    render_json_error(e.message, 401)
  end

  rescue_from AppErrors::ForbiddenError do |e|
    render_json_error(e.message, 403)
  end

  def render_json_error(msgs, status)
    render json: { status: "error", messages: Array(msgs) }, status:
  end
end
