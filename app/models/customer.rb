class Customer < ApplicationRecord
  has_secure_password

  validates :email, presence: true, uniqueness: true
  validates :password, presence: true, length: { minimum: 6 }, if: :password_required?

  private

  def password_required?
    new_record? || !password.nil?
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
