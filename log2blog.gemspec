Gem::Specification.new do |s|
  s.name        = 'log2blog'
  s.version     = '0.0.1'
  s.date        = '2016-07-08'
  s.summary     = "Generates a Markdown version of a git commit history"
  s.description = "Convert git logs to a Markdown blog post"
  s.authors     = ["Josh Justice"]
  s.email       = 'josh@need-bee.com'
  s.files       = ["lib/log2blog.rb"]
  s.executables = ["log2blog"]
  s.homepage    =
    'https://github.com/CodingItWrong/log2blog'
  s.license       = 'MIT'

  s.add_dependency "github_api", "~> 0.14"
  s.add_dependency "dotenv", "~> 2.1"
end
