class Api::V1::IeStatementsController < Api::ApiController
  def create
    customer = Customer.find(params[:customer_id])
    ie_statement = customer.ie_statements.new(ie_statement_params)

    if ie_statement.save
      render locals: { ie_statement: }, status: :created
    else
      render_json_error(ie_statement.errors.full_messages, :unprocessable_entity)
    end
  end

  private

  def ie_statement_params
    params.require(:ie_statement).permit(:name, incomes_attributes: [ :category, :amount ], expenditures_attributes: [ :category, :amount ])
  end
end
