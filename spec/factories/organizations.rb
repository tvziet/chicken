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

FactoryBot.define do
  factory :organization do
    sequence(:name) { |n| "Organization #{n}" }
  end
end
