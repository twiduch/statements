module Api
  module V1
    class ExpendituresController < Api::ApiController
      def show
        @expenditure = Expenditure.find(params[:id])
        raise(ActiveRecord::RecordNotFound) unless @expenditure.customer == current_user
      end

      def create
        ie_statement = current_user.ie_statements.find(params[:ie_statement_id])
        @expenditure = ie_statement.expenditures.new(expenditures_params)

        if @expenditure.save
          render status: :created
        else
          render_json_error(@expenditure.errors.full_messages, :unprocessable_entity)
        end
      end

      private

      def expenditures_params
        params.require(:expenditure).permit(:category, :amount)
      end
    end
  end
end
