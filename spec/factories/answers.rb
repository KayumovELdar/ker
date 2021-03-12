FactoryBot.define do
  factory :answer do
    title { 'MyString_q' }
    body { 'MyText_q' }
    question
    user

    trait :invalid do
      title { nil }
    end
  end
end
