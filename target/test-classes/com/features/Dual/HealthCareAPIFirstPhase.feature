Feature: Dual: Create Declaration

  @smoke2
  Scenario: Verify Oauth Expiration works with in timelimit 3599 seconds
#  Scenario Outline: Test

    #Create Declaration in Dual Services
    Given I set endpoint as "<--config.props/BASE_URI_DUAL_TO_SEQUL" with API "/sequel/declaration"
    And I set Oauth Header with "<--config.props/DualToSequel_ID" and "<--config.props/DualToSequel_Secret" and "<--config.props/DualToSequel_Scope" and "<--config.props/DualToSequel_grant_type" and "<--config.props/DualToSequel_URL"
    And I print response
    And I save value "$..ext_expires_in-->try.txt/anothername"
    And I save value "$..access_token-->Oauth.txt/Token"
    And I add request header "Authorization" as "Bearer <--Oauth.txt/Token"
    And I add request header "Content-Type" as "<--config.props/CONTENT-TYPE"
    And I add request header "Ocp-Apim-Subscription-Key" as "<--config.props/OCP-APIM-SUBSCRIPTION-KEY"
    When I use json template "data/payload/DualToSequl/Declaration.json"
    And I mention "$..policyDsc" as "Auto_cucu_$$timeStamp"
    And I print request

    # Below Code will invoke Post API call and create Declaration in Eclipse
    Then I invoke the POST API with json payload
    And I print response
    And I save response to "responseReceived/res"
    And I save value "$..messageId-->message.txt/MessageID"
    And I print from file "<--message.txt/res"
    And I wait for "2" seconds


    # Below code will fetch Request ID and Assert Status Code and Created.
    Given I set endpoint as "<--config.props/BASE_URI_DUAL_TO_SEQUL" with API "/sequel/status/" along with "<--message.txt/MessageID"
    And I add request header "Authorization" as "Bearer <--Oauth.txt/Token"
    And I add request header "Content-Type" as "<--config.props/CONTENT-TYPE"
    And I add request header "Ocp-Apim-Subscription-Key" as "<--config.props/OCP-APIM-SUBSCRIPTION-KEY"
    And I print request
    Then I invoke the GET API
    And I print response
    And I verify the status code to be "200"
    And I verify "$..status" contains text "Accepted"
    And I verify "$..statusCode" contains text "202"

#    Below Code is used to recursive to confirm status is changed from Accepted to Created
    Given I set endpoint as "<--config.props/BASE_URI_DUAL_TO_SEQUL" with API "/sequel/status/" along with "<--message.txt/MessageID"
    And I add request header "Authorization" as "Bearer <--Oauth.txt/Token"
    And I add request header "Content-Type" as "<--config.props/CONTENT-TYPE"
    And I add request header "Ocp-Apim-Subscription-Key" as "<--config.props/OCP-APIM-SUBSCRIPTION-KEY"
    And Verify status is changed to Accepted from Created
    And I verify "$..status" contains text "Created"
    And I verify "$..statusCode" contains text "201"




#
#     Examples:
#      | ErrorMessage | Code |
#      | Message 1 | 200      |
#      | Message 2 | 200      |
#      | Message 3 | 200      |


  Scenario: Timestamp
#      Given Get Current TimeStamp
#      And I print "Shankar"
#      And I print from file "<--Oauth.txt/Token"
      And I print given value "Test$$timeStamp"
#      And I print given value "Test$$rndString"