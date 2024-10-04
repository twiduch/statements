json.extract! @ie_statement, :id, :name, :created_at, :updated_at

json.customer do
  json.id @ie_statement.customer.id
end

json.incomes @ie_statement.incomes do |income|
  json.id income.id
  json.category income.category
  json.amount income.amount
end

json.expenditures @ie_statement.expenditures do |expenditure|
  json.id expenditure.id
  json.category expenditure.category
  json.amount expenditure.amount
end
