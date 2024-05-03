FactoryBot.define do
  factory :admin_user, class: User do
    name { 'テストユーザー' }
    email { 'test1@example.com' }
    password { 'password' }
  end
end
