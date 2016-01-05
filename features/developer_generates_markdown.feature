Feature: developer generates markdown

  As a developer
  I want to convert my commit history to markdown
  So I can post it as a blog post

  Scenario: generate markdown
    Given there is a GitHub repo
    And I have a GitHub token
    When I generate markdown
    Then I should see the correct markdown
