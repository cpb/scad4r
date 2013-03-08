Feature: I want to know what openscad's done with my scad file

  Scenario: Errors in geometry
    Given I have a Scad4r::Runner with a Scad4r::ResultParser
    And a file named "not_two_manifold.scad" with:
    """
    cube([20, 20, 20]);
    translate([-20, -20, 0]) cube([20, 20, 20]);
    cube([50, 50, 5], center = true);
    """
    When I run "not_two_manifold.scad" through the Scad4r::Runner
    Then the results should be an error
