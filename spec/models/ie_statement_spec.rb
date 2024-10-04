require 'rails_helper'

RSpec.describe IeStatement, type: :model do
  subject(:ie_statement) { build(:ie_statement, customer: customer) }
  let(:customer) { create(:customer) }

  describe 'validations' do
    it 'is valid with valid attributes' do
      expect(ie_statement).to be_valid
    end

    it 'is not valid without a name' do
      ie_statement.name = nil
      expect(ie_statement).to_not be_valid
      expect(ie_statement.errors[:name]).to include("can't be blank")
    end

    it 'is not valid without a customer' do
      ie_statement.customer = nil
      expect(ie_statement).to_not be_valid
      expect(ie_statement.errors[:customer]).to include("must exist")
    end
  end

  describe 'nested attributes' do
    context 'with incomes and expenditures' do
      subject(:ie_statement) do
        build(:ie_statement, name: 'Monthly Budget', customer: customer,
          incomes_attributes: [ { category: 'Salary', amount: 300000 } ],
          expenditures_attributes: [ { category: 'Rent', amount: 100000 } ]
        )
      end

      it 'accepts nested attributes for incomes' do
        expect(ie_statement.save).to be true
        expect(ie_statement.incomes.count).to eq(1)
      end

      it 'accepts nested attributes for expenditures' do
        expect(ie_statement.save).to be true
        expect(ie_statement.expenditures.count).to eq(1)
      end
    end
  end

  describe 'update aggregates' do
    subject(:ie_statement) do
      build(:ie_statement, name: 'Monthly Budget', customer: customer,
        incomes_attributes: incomes,
        expenditures_attributes: expenditures
      )
    end
    let(:incomes) { [ { category: 'Salary', amount: 300000 } ] }
    let(:expenditures) { [ { category: 'Rent', amount: 100000 } ] }

    before do
      ie_statement.save
    end

    it 'updates disposable_income and rating correctly' do
      expect(ie_statement.disposable_income).to eq(200000)
      expect(ie_statement.rating).to eq('C')
    end

    context 'when grade A' do
      context '<10%' do
        let(:expenditures) { [ { category: 'Rent', amount: 30000 - 1 } ] }

        it 'updates rating correctly' do
          expect(ie_statement.rating).to eq('A')
        end
      end
    end

    context 'when grade B' do
      context '10%' do
        let(:expenditures) { [ { category: 'Rent', amount: 30000 } ] }

        it 'updates rating correctly' do
          expect(ie_statement.rating).to eq('B')
        end
      end
      context '<30%' do
        let(:expenditures) { [ { category: 'Rent', amount: 90000 - 1 } ] }

        it 'updates rating correctly' do
          expect(ie_statement.rating).to eq('B')
        end
      end
    end

    context 'when grade C' do
      context '30%' do
        let(:expenditures) { [ { category: 'Rent', amount: 90000 } ] }

        it 'updates rating correctly' do
          expect(ie_statement.rating).to eq('C')
        end
      end
      context '<50%' do
        let(:expenditures) { [ { category: 'Rent', amount: 150000 - 1 } ] }

        it 'updates rating correctly' do
          expect(ie_statement.rating).to eq('C')
        end
      end
    end

    context 'when grade D' do
      context '>50%' do
        let(:expenditures) { [ { category: 'Rent', amount: 150000 } ] }

        it 'updates rating correctly' do
          expect(ie_statement.rating).to eq('D')
        end
      end
    end
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
