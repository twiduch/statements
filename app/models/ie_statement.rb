class IeStatement < ApplicationRecord
  belongs_to :customer
  has_many :incomes, dependent: :destroy
  has_many :expenditures, dependent: :destroy

  validates :name, presence: true

  accepts_nested_attributes_for :incomes, :expenditures
end

# == Schema Information
#
# Table name: ie_statements
#
#  id          :integer          not null, primary key
#  name        :string
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  customer_id :integer          not null
#
# Indexes
#
#  index_ie_statements_on_customer_id  (customer_id)
#
# Foreign Keys
#
#  customer_id  (customer_id => customers.id)
#
