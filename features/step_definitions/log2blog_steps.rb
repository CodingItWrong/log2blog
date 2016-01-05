Given(/^there is a GitHub repo$/) do
  @user = 'TestUser'
  @repo = 'TestRepo'
end

Given(/^I have a GitHub token$/) do
  @token = 'TestToken'
end

When(/^I generate markdown$/) do
  @markdown = Log2Blog::Generator.new( @token ).generate_markdown( @user, @repo )
end

Then(/^I should see the correct markdown$/) do
  expect(@markdown).to eq <<-EOT
First commit

```diff
+ Hello, world!
```

Second commit

```diff
- Hello, world!
+ Hello, universe!
```
  EOT
end
