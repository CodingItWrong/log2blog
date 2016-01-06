FactoryGirl.define do
  factory :commit, class: Log2Blog::Commit do
    sequence(:sha) { |n| "SHA#{n}" }
    sequence(:message) { |n| "This is commit message #{n}" }
    files { FactoryGirl.build_list(:commit_file, 2) }

    initialize_with { Log2Blog::Commit.new( sha: sha, message: message, files: files ) }
  end
end
