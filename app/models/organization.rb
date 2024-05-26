# == Schema Information
#
# Table name: organizations
#
#  id         :bigint           not null, primary key
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
#  index_organizations_on_short_name  (short_name) UNIQUE
#
class Organization < ApplicationRecord
  validates :name, presence: true
  validates :short_name, presence: true, format: /\A[a-z0-9_]+\z/i, uniqueness: true
  validates :url, format: { with: URI::DEFAULT_PARSER.make_regexp, message: "it should look like 'https://www.example.com'" }, allow_blank: true
  validates :email, format: { with: URI::MailTo::EMAIL_REGEXP, message: "it should look like 'test@example.com'" }, allow_blank: true
end
