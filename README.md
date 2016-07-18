# log2blog

If you're writing a programming tutorial and you want an accompanying git repository showing the steps you took, then there can be a lot of duplication between the post and the git repository. It can be easy for them to get out of sync, and that's confusing for your readers. `log2blog` helps with this problem by automatically generating a blog post from your git log. All you have to do is put good descriptions of your steps in each commit message, and you'll end up with a great blog post with headings, file diffs, and descriptions matching your commits. Plus, you can easily regenerate any time your git log changes to ensure they're always in sync.

As an example of an article generated via Log2Blog, see [learntdd.in/rails](http://learntdd.in/rails/).

## Example

Say you're writing a blog post on how to create a todo list app in Rails. In a project repo, for each step you want to appear in the blog post, make a separate commit with those changes. Be sure to include a verbose commit message, because it will be a big part of your post. For example, say you have one commit in your todo list app that adds the line `belongs_to :user` to the following file:

#### app/models/todo.rb

```ruby
class Todo < ApplicationRecord
  belongs_to :user
end
```

With the commit message:

```
Relate todo to user

Creates the many-to-one relationship between the todo and the user.
```

Say your project is visible on GitHub at https://github.com/YourGitUserName/YourToDoListAppName. When you're ready to generate a post from your git commit history, run:

`log2blog YourGitUserName/YourToDoListAppName`

This will output markdown corresponding to each commit, oldest to newest. It might render in a Jekyll blog, for example, as:

<img src="https://raw.githubusercontent.com/CodingItWrong/log2blog/master/docs/images/output-example.png" style="border: solid 2px black" />

## Installation

To install log2blog globally so you can run `log2blog` from anywhere, clone or download the repo from GitHub.

If you'd like to install `log2blog` locally in a Ruby project, add it to your Gemfile:

```ruby
gem "log2blog", github: "CodingItWrong/log2blog", branch: "master"
```

Then run `bundle install`.

If log2blog is installed locally, you can run it with `bundle exec log2blog`.

## Usage

To connect to GitHub you'll need a GitHub OAuth token. You can create one for your account on the [Personal Access Tokens page](https://github.com/settings/tokens).

To output the entire history of the repo converted to markdown:

```
bin/log2blog GITHUB_USERNAME/REPO_NAME --token GITHUB_OAUTH_TOKEN
```

You can also specify a commit hash to start from:

```
bin/log2blog GITHUB_USERNAME/REPO_NAME 4342fbec671ab2ce202aa4997e1388b8bcbb48a1 --token GITHUB_OAUTH_TOKEN
```

You can skip outputting files matching certain names in all commits:

```
bin/log2blog GITHUB_USERNAME/REPO_NAME 4342fbec671ab2ce202aa4997e1388b8bcbb48a1 --skip db/schema.rb --token GITHUB_OAUTH_TOKEN
```

## Why Tho

If you think about it, a programming tutorial article is not all that different from a git commit log. You have a series of steps, each of which changes one or more files, along with an accompanying explanation. But an article isn't executable; and, conversely, a git commit log isn't _quite_ as readable.

Log2Blog allows you to generate an article from a git commit log, so that as you make changes to the repo history, the article can automatically be regenerated. It also links to each commit in GitHub individually, so that readers can interact with it, check out that version of the code, etc.

## Contributing

Contributions to log2blog's code, tests, and documentation are welcome! To contribute:

1. Fork the project ( http://github.com/CodingItWrong/log2blog/fork )
2. Create your feature branch (git checkout -b my-new-feature)
3. Commit your changes (git commit -am 'Add some feature')
4. Push to the branch (git push origin my-new-feature)
5. Create a new Pull Request

## License

MIT. See `LICENSE.txt` for details.
