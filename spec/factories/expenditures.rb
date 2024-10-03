FactoryBot.define do
  factory :expenditure do
    ie_statement
    category { "Mortage" }
    amount { Faker::Number.between(from: 100, to: 10_000_000) }
  end
end

# == Schema Information
#
# Table name: expenditures
#
#  id              :integer          not null, primary key
#  amount          :integer
#  category        :string
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  ie_statement_id :integer          not null
#
# Indexes
#
#  index_expenditures_on_ie_statement_id  (ie_statement_id)
#
# Foreign Keys
#
#  ie_statement_id  (ie_statement_id => ie_statements.id)
#
