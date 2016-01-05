class GithubApi
  def history( user, repo )
    [
      Log2Blog::Commit.new( "1", "Oldest commit", [
        Log2Blog::CommitFile.new( "test.rb", "+ Hello, world!" )
      ]),
      Log2Blog::Commit.new( "2", "Newest commit", [
        Log2Blog::CommitFile.new( "test.rb", "- Hello, world!\n+ Hello, universe!" )
      ]),
    ]
  end
end

Given(/^there is a GitHub repo$/) do
  @user = 'TestUser'
  @repo = 'TestRepo'
end

When(/^I generate markdown$/) do
  @markdown = Log2Blog::Generator.new( GithubApi.new ).generate_markdown( @user, @repo )
end

Then(/^I should see the correct markdown$/) do
  expect(@markdown).to eq <<-EOT
Oldest commit

test.rb

```diff
+ Hello, world!
```

Newest commit

test.rb

```diff
- Hello, world!
+ Hello, universe!
```
  EOT
end
