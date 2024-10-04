class Expenditure < ApplicationRecord
  belongs_to :ie_statement
  has_one :customer, through: :ie_statement

  validates :category, presence: true
  validates :amount, presence: true, numericality: { greater_than: 0 }
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
