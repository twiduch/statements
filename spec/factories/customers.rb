FactoryBot.define do
  factory :customer do
    name { Faker::Name.name }
    email { Faker::Internet.unique.email }
    password { 'password123' }
  end
end

# == Schema Information
#
# Table name: customers
#
#  id              :integer          not null, primary key
#  email           :string           not null
#  name            :string
#  password_digest :string           not null
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#
# Indexes
#
#  index_customers_on_email  (email) UNIQUE
#
