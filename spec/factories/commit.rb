FactoryGirl.define do
  factory :commit, class: Log2Blog::Commit do
    user "user"
    repo "repo"
    sequence(:sha) { |n| "SHA#{n}" }
    sequence(:message) { |n| "This is commit message #{n}" }
    files { build_list(:commit_file, 2) }

    initialize_with { new( user: user, repo: repo, sha: sha, message: message, files: files ) }
  end
end
