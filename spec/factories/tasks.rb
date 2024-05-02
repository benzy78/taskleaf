FactoryBot.define do
  factory :task do
    name {"テストを書く"}
    description {"Rspec&Capybaraを準備する"}
    user
  end
end