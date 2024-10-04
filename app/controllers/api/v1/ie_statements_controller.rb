module Api
  module V1
    class IeStatementsController < Api::ApiController
      def index
        @ie_statements = current_user.ie_statements
      end

      def show
        @ie_statement = current_user.ie_statements.find(params[:id])
      end

      def create
        raise(AppErrors::ForbiddenError, "You are not allowed to create statement for different user") unless params[:customer_id] == current_user.id.to_s

        customer = Customer.find(params[:customer_id])
        @ie_statement = customer.ie_statements.new(ie_statement_params)

        if @ie_statement.save
          render status: :created
        else
          render_json_error(@ie_statement.errors.full_messages, :unprocessable_entity)
        end
      end

      private

      def ie_statement_params
        params.require(:ie_statement).permit(:name, incomes_attributes: [ :category, :amount ], expenditures_attributes: [ :category, :amount ])
      end
    end
  end
end
