require 'rails_helper'

RSpec.describe Income, type: :model do
  subject(:income) { build(:income, ie_statement: ie_statement) }
  let(:ie_statement) { create(:ie_statement) }

  describe 'validations' do
    it 'is valid with valid attributes' do
      expect(subject).to be_valid
    end


    it 'is not valid without a category' do
      income.category = nil

      expect(income).to_not be_valid
      expect(income.errors[:category]).to include("can't be blank")
    end

    it 'is not valid without an amount' do
      income.amount = nil
      expect(income).to_not be_valid
      expect(income.errors[:amount]).to include("can't be blank")
    end

    it 'is not valid with a non-numeric amount' do
      income.amount = 'abc'
      expect(income).to_not be_valid
      expect(income.errors[:amount]).to include("is not a number")
    end

    it 'is not valid with an amount less than or equal to 0' do
      income.amount = 0
      expect(income).to_not be_valid
      expect(income.errors[:amount]).to include("must be greater than 0")
    end
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
