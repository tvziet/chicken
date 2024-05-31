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
#  index_organizations_on_email       (email) UNIQUE
#  index_organizations_on_name        (name) UNIQUE
#  index_organizations_on_short_name  (short_name) UNIQUE
#

FactoryBot.define do
  factory :organization do
    sequence(:name) { |n| "Organization #{n}" }
  end
end
