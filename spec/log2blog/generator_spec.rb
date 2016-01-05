require "spec_helper"

module Log2Blog
  describe Generator do
    describe "#generate_markdown" do
      let(:token) { "TestToken" }
      let(:user) { "TestUser" }
      let(:repo) { "TestRepo" }
      let(:generator) { Log2Blog::Generator.new( token ) }

      it "returns the correct markdown" do
        markdown = generator.generate_markdown( user, repo )
        expect(markdown).to eq <<-EOT
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
    end
  end
end
