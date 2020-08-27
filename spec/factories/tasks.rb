FactoryBot.define do
  factory :task do
    title { |n| "test#{n}" }
    status { 0 }
    association :user
  end
end
