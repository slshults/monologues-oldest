Feature: Search
  In order to find a monologue
  As a student
  I want to search all plays for specific words

  Scenario: Find the monologue that mentions Yorick
    Given I am on the monologues page
    When I search for "yorick"
    Then I should see
      """
      Alas! poor Yorick.
      """

  Scenario: Find out how many monolouges mention tree
    Given I am on the monologues page
    When I search for "tree"
    Then I should see
      """
      16 monologues match your search!
      """

  Scenario: Find all Hamlet monologues that mention tree
    Given I am on the hamlet page
    When I search for "tree"
    Then I should see
      """
      2 monologues match your search!
      """

  Scenario: Find that no monologues mention Zebra
    Given I am on the monologues page
    When I search for "zebra"
    Then I should see
      """
      Alas, no monologues match your search
      """
