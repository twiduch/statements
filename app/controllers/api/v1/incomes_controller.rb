module Api
  module V1
    class IncomesController < Api::ApiController
      def show
        @income = Income.find(params[:id])
        raise(ActiveRecord::RecordNotFound) unless @income.customer == current_user
      end

      def create
        ie_statement = current_user.ie_statements.find(params[:ie_statement_id])
        @income = ie_statement.incomes.new(income_params)

        if @income.save
          render status: :created
        else
          render_json_error(@income.errors.full_messages, :unprocessable_entity)
        end
      end

      private

      def income_params
        params.require(:income).permit(:category, :amount)
      end
    end
  end
end
