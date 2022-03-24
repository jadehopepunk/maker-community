FactoryBot.define do
  factory :user do
    password { 'password' }

    factory :jade do
      display_name { 'Jade' }
      email { 'jade@user.com' }
    end

    factory :bilbo do
      display_name { 'Bilbo' }
      email { 'bilbo@user.com' }
    end
  end

  factory :event do
    factory :spoon_carving do
      title { 'Spoon Carving' }
    end

    factory :unplugged_night do
      slug { 'unplugged-night' }
      title { 'Unplugged Night' }
    end

    factory :open_for_making do
      slug { 'open-for-making' }
      title { 'Open for Making' }
    end
  end
end
