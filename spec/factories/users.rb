FactoryBot.define do
  sequence(:email){|i| "email#{i}@example.com"}
  sequence(:name){|i| "Example Name #{i}"}

  factory :user do
    email
    name
  end
end
