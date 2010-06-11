Feature: Navigation
  In order to find monologues
  As an actor
  I want to browse the site

  Scenario: Find all Women / Hamlet monologues
    Given I am on the women/hamlet page
    Then I should see
      """
      O my lord, my lord, I have been so affrighted
      """
    Then I should not see
      """
      Alas! poor Yorick.
      """

#  Scenario: Find all Men / Midsummer monologues
#    Given I am on the women/midsummer page
#    # men
#    Then I should see
#      """
#      Full of vexation come I, with complaint
#      """
#    # women
#    Then I should not see
#      """
#      Puppet? Why so?
#      """
#    # both
#    Then I should see
#      """
#      Puck
#      """
