FactoryBot.define do
  factory :user do
    password { 'password' }
    sign_up_status { 'full' }

    factory :jade do
      display_name { 'Jade' }
      email { 'jade@user.com' }
    end

    factory :bilbo do
      display_name { 'Bilbo' }
      email { 'bilbo@user.com' }
    end

    factory :unclaimed_user do
      display_name { 'Unclaimed' }
      email { 'unclaimed@user.com' }
      sign_up_status { 'unclaimed' }
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

  factory :event_session do
    factory :spoon_carving_session do
      start_at { Time.current + 1.day }
      end_at { start_at + 1.hour }
      event { build(:spoon_carving) }
    end
  end

  factory :event_booking do
    status { 'complete' }
  end
end
