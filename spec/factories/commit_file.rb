FactoryGirl.define do
  factory :commit_file, class: Log2Blog::CommitFile do
    sequence(:name) { |n| "file#{n}.txt" }
    sequence(:diff) { |n| "diff #{n}" }

    initialize_with { new( name: name, diff: diff ) }
  end
end
