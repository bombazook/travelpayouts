FactoryBot.define do
  factory :subscription do
    association :user, strategy: :build
    association :program, strategy: :build
    banned { false }
  end
end

