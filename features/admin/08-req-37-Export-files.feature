@req-37 @done @javascript
Feature: Export files

  In order to export the Digital Objects metadata and asset
  As an authenticated and authorised user
  I want to be able to download the metadata
  And the asset file to my local drive

  Background:
    Given I am logged in as "user1" in the group "cm"

  Scenario: Export DigitalObject's metadata when I have edit/manage permissions
    Given I create an object and save the pid
    When I go to the "object" "show" page for "the saved pid"
    Then I should see a "rights statement"
    And I should see a link to download metadata


  Scenario: View DigitalObject's full metadata when I have edit/manage permissions
    Given I create an object and save the pid
    When I go to the "object" "show" page for "the saved pid"
    Then I should see a "rights statement"
    And I should see a link to full metadata
    Then I should see a section with id "dri_metadata_modal_id"
    When I follow the link to full metadata
    Then I should see a section with id "dri_metadata_modal_id"
    And I should see 1 visible element ".modal-body .dri_object_metadata_readview"
    And I should see "2013-01-16" within ".modal-body .dri_object_metadata_readview"
    And I should see "test@test.com" within ".modal-body .dri_object_metadata_readview"
    And I should see "Created using the web form" within ".modal-body .dri_object_metadata_readview"

  Scenario: Export a DigitalObject's asset when I have edit/manage permissions
    Given I create an object and save the pid
    When I go to the "object" "modify" page for "the saved pid"
    And I attach the asset file "sample_audio.mp3"
    And I press the button to "upload a file"
    Then I should see a "rights statement"
    And I should see a link to download asset

