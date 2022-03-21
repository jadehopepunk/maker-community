FactoryBot.define do
  factory :user do
    password { 'password' }

    factory :jade do
      display_name { 'Jade' }
      email { 'jade@user.com' }
    end
  end

  factory :event do
    factory :spoon_carving do
      title { 'Spoon Carving' }
    end
  end
end