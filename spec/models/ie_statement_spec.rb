require 'rails_helper'

RSpec.describe IeStatement, type: :model do
  subject(:statement) { build(:ie_statement, customer: customer) }
  let(:customer) { create(:customer) }

  describe 'validations' do
    it 'is valid with valid attributes' do
      expect(statement).to be_valid
    end

    it 'is not valid without a name' do
      statement.name = nil
      expect(statement).to_not be_valid
      expect(statement.errors[:name]).to include("can't be blank")
    end

    it 'is not valid without a customer' do
      statement.customer = nil
      expect(statement).to_not be_valid
      expect(statement.errors[:customer]).to include("must exist")
    end
  end

  describe 'nested attributes' do
    context 'with incomes and expenditures' do
      subject(:statement) do
        build(:ie_statement, name: 'Monthly Budget', customer: customer,
          incomes_attributes: [{ category: 'Salary', amount: 300_000 }],
          expenditures_attributes: [{ category: 'Rent', amount: 100_000 }]
        )
      end

      it 'accepts nested attributes for incomes' do
        expect(statement.save).to be true
        expect(statement.incomes.count).to eq(1)
      end

      it 'accepts nested attributes for expenditures' do
        expect(statement.save).to be true
        expect(statement.expenditures.count).to eq(1)
      end
    end
  end
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
