FactoryBot.define do
  factory :ie_statement do
    name { "Statement1" }
    customer
  end
end

# == Schema Information
#
# Table name: ie_statements
#
#  id                :integer          not null, primary key
#  disposable_income :integer
#  name              :string
#  rating            :string
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#  customer_id       :integer          not null
#
# Indexes
#
#  index_ie_statements_on_customer_id  (customer_id)
#
# Foreign Keys
#
#  customer_id  (customer_id => customers.id)
#
