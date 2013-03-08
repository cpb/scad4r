Feature: I want to run openscad from ruby

  Scenario: Run openscad on a file
    Given I have a Scad4r::Runner
    And a file named "cube.scad" with:
    """
    cube(10,10,10);
    """
    When I run "cube.scad" through the Scad4r::Runner
    And a file named "cube.stl" should exist
