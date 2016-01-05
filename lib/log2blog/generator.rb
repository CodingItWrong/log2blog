module Log2Blog
  class Generator
    def initialize( token )
    end

    def generate_markdown( user, repo )
      <<-EOT
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
