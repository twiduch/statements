class IeStatement < ApplicationRecord
  belongs_to :customer
  has_many :incomes, dependent: :destroy
  has_many :expenditures, dependent: :destroy

  validates :name, presence: true
  accepts_nested_attributes_for :incomes, :expenditures

  after_touch :update_aggregates

  def total_income
    incomes.sum(:amount)
  end

  def total_expenditure
    expenditures.sum(:amount)
  end

  private

  def update_aggregates
    rating, disposable_income = calculate_aggregates
    update_column(:disposable_income, disposable_income) unless self.disposable_income == disposable_income
    update_column(:rating, rating) unless self.rating == rating
  end

  def calculate_aggregates
    income = total_income
    expenditure = total_expenditure
    ratio = income > 0 ? ((expenditure.to_f / income) * 100).floor : 0

    rating = case ratio
    in 0...10
      "A"
    in 10...30
      "B"
    in 30...50
      "C"
    else
      "D"
    end

    [ rating, income - expenditure ]
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
