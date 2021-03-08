FactoryBot.define do
  factory :answer do
    title { 'MyString_q' }
    body { 'MyText_q' }
    question {nil}
  end
end
