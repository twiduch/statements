require 'rails_helper'

RSpec.describe Customer, type: :model do
  subject { described_class.new(email: 'test@example.com', password: 'password123') }

  describe 'validations' do
    it 'is valid with valid attributes' do
      expect(subject).to be_valid
    end

    it 'is not valid without an email' do
      subject.email = nil
      expect(subject).to_not be_valid
      expect(subject.errors[:email]).to include("can't be blank")
    end

    it 'is not valid with a duplicate email' do
      described_class.create!(email: 'test@example.com', password: 'password123')
      expect(subject).to_not be_valid
      expect(subject.errors[:email]).to include("has already been taken")
    end

    it 'is not valid without a password' do
      subject.password = nil
      expect(subject).to_not be_valid
      expect(subject.errors[:password]).to include("can't be blank")
    end

    it 'is not valid if password is less than 6 characters' do
      subject.password = 'short'
      expect(subject).to_not be_valid
      expect(subject.errors[:password]).to include("is too short (minimum is 6 characters)")
    end
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
