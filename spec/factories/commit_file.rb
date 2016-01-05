FactoryGirl.define do
  factory :commit_file, class: Log2Blog::CommitFile do
    sequence(:filename) { |n| "file#{n}.txt" }
    sequence(:patch) { |n| "patch #{n}" }
  end
end
