# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :eco_system do
    name "staging"
  end

  factory :aws_eco_system, parent: :eco_system do
    provider "aws"
    provider_access_id "RandomStuff"
    provider_access_key "RandomStuff"
  end

  factory :data_center_eco_system, parent: :eco_system do
    provider "data_center"
  end

end
