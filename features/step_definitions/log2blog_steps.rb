class GithubApi
  def all( user, repo )
    [
      {
        "sha" => "2",
        "commit" => {
          "message" => "Newest commit"
        }
      },
      {
        "sha" => "1",
        "commit" => {
          "message" => "Oldest commit"
        }
      }
    ]
  end

  def get( user, repo, sha )
    Struct.new(:body).new({
      "1" => {
        "files" => [
          {
            "filename" => "test.rb",
            "patch" => "+ Hello, world!"
          }
        ]
      },
      "2" => {
        "files" => [
          {
            "filename" => "test.rb",
            "patch" => "- Hello, world!\n+ Hello, universe!"
          }
        ]
      }
    }[sha]);
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
