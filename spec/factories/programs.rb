FactoryBot.define do
  sequence(:title) { |n| "Example title #{n}" }
  sequence(:description) { |n| "Example description #{n}" }

  factory :program do
    title
    description
  end
end
