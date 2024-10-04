class AddRatingAndDisposableIncomeToIeStatements < ActiveRecord::Migration[7.2]
  def change
    add_column :ie_statements, :rating, :string
    add_column :ie_statements, :disposable_income, :integer
  end
end
