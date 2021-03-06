FactoryBot.define do
  factory :supply_teachers_branch_search_result, class: SupplyTeachers::BranchSearchResult do
    id { SecureRandom.uuid }
    name { Faker::Company.unique.name }
    supplier_name { Faker::Company.unique.name }
    telephone_number { Faker::PhoneNumber.unique.phone_number }
    contact_name { Faker::Name.unique.name }
    contact_email { Faker::Internet.unique.email }
    initialize_with { new(attributes) }
  end
end
