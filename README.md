# Log2Blog

Convert a GitHub commit log into markdown for a blog post, page, etc.

As an example of an article generated via Log2Blog, see [learntdd.in/rails](http://learntdd.in/rails/).

## Usage

Not yet set up to be an installable gem; for now, download the repo and run it from the project root.

```
bundle install
echo "GITHUB_OAUTH_TOKEN=b52c0626e6badbad25d1c5c18f33c2ff0275641c" > .env
bin/log2blog github-username/repo-name
```

You can also specify a commit hash to start from:

```
bin/log2blog github-username/repo-name 4342fbec671ab2ce202aa4997e1388b8bcbb48a1
```

## Why Tho

If you think about it, a programming tutorial article is not all that different from a git commit log. You have a series of steps, each of which changes one or more files, along with an accompanying explanation. But an article isn't executable; and, conversely, a git commit log isn't _quite_ as readable.

Log2Blog allows you to generate an article from a git commit log, so that as you make changes to the repo history, the article can automatically be regenerated. It also links to each commit in GitHub individually, so that readers can interact with it, check out that version of the code, etc.

## License

MIT
