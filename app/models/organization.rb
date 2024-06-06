# == Schema Information
#
# Table name: organizations
#
#  id         :uuid             not null, primary key
#  city       :string
#  email      :string
#  name       :string
#  short_name :string
#  state      :string
#  street     :string
#  url        :string
#  zipcode    :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
# Indexes
#
#  index_organizations_on_name_and_short_name_and_email  (name,short_name,email) UNIQUE
#
class Organization < ApplicationRecord
  validates :name, presence: true
  validates :short_name, format: /\A[a-z0-9_]+\z/i, if: -> { short_name.present? }
  validates :url, format: { with: URI::DEFAULT_PARSER.make_regexp, message: "it should look like 'https://www.example.com'" }, allow_blank: true
  validates :email, format: { with: URI::MailTo::EMAIL_REGEXP, message: "it should look like 'test@example.com'" }, allow_blank: true
  validates :name, uniqueness: { scope: [:short_name, :email], message: 'name, short_name and email combination must be unique' }
end
