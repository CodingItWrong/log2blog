# Log2Blog

Convert a GitHub commit log into markdown for a blog post, page, etc.

## Usage

Not yet set up to be an installable gem; for now, download the repo and run it
from the project root.

```
echo "GITHUB_OAUTH_TOKEN=b52c0626e6badbad25d1c5c18f33c2ff0275641c" > .env
bin/log2blog github-username/repo-name
```

You can also specify a commit hash to start from:

```
bin/log2blog github-username/repo-name 4342fbec671ab2ce202aa4997e1388b8bcbb48a1
```

## License

MIT
