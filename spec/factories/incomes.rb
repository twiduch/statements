FactoryBot.define do
  factory :income do
    ie_statement
    category { "Salary" }
    amount { Faker::Number.between(from: 100, to: 10_000_000) }
  end
end

# == Schema Information
#
# Table name: incomes
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
#  index_incomes_on_ie_statement_id  (ie_statement_id)
#
# Foreign Keys
#
#  ie_statement_id  (ie_statement_id => ie_statements.id)
#
