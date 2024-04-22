Feature: Dual: API Phase 2 Test Health Care Premium

  @smoke  @Premium  @Phase2
  Scenario Outline: Execute Premium Transaction API with different set of transType as present in Excel
    #    Test Case id in Azure Devops 10046

    #    Create Declaration in Dual Services
    Given I set endpoint as "<--config.props/BASE_URI_DUAL_TO_SEQUL" with API "/sequel/declaration"
    And I set Oauth Header with "<--config.props/DualToSequel_ID" and "<--config.props/DualToSequel_Secret" and "<--config.props/DualToSequel_Scope" and "<--config.props/DualToSequel_grant_type" and "<--config.props/DualToSequel_URL"
    And I print response
    And I save value "$..access_token-->Oauth.txt/Token"
    And I add request header "Authorization" as "Bearer <--Oauth.txt/Token"
    And I add request header "Content-Type" as "<--config.props/CONTENT-TYPE"
    And I add request header "Ocp-Apim-Subscription-Key" as "<--config.props/OCP-APIM-SUBSCRIPTION-KEY"
    When I use json template "data/payload/DualToSequl/Declaration.json"
    And I mention "$..policyDsc" as "A_Premium_transType_$$timeStamp"
    And I mention "$..inceptionDate" as "<--TimeStamp.txt/inceptionDate"
    And I mention "$..expiryDate" as "<--TimeStamp.txt/expiryDate"

    And I mention "$.message.orgs[1].name" as "Test Insured <--TimeStamp.txt/timestamp"
    And I mention "$.message.orgs[1].org.orgNames[0].name" as "Test Insured <--TimeStamp.txt/timestamp"
    And I mention "$..roleDsc" as "Test Insured <--TimeStamp.txt/timestamp"
    And I print request

    #    Below Code will invoke Post API call and create Declaration in Eclipse
    Then I invoke the POST API with json payload
    And I print response
    And I save response to "Response.txt/DeclarationResponse"
    And I save value "$..messageId-->Message.txt/Declaration_MessageID"
    And I print from file "<--message.txt/Declaration_MessageID"
    And I wait for "2" seconds


    #    Below code will fetch Request ID and Assert Status Code and Created.
    Given I set endpoint as "<--config.props/BASE_URI_DUAL_TO_SEQUL" with API "/sequel/status/" along with "<--message.txt/Declaration_MessageID"
    And I add request header "Authorization" as "Bearer <--Oauth.txt/Token"
    And I add request header "Content-Type" as "<--config.props/CONTENT-TYPE"
    And I add request header "Ocp-Apim-Subscription-Key" as "<--config.props/OCP-APIM-SUBSCRIPTION-KEY"
    And I print request
    Then I invoke the GET API
    And I print response
    And I verify the status code to be "200"
    And I verify "$..status" contains text "Accepted"
    And I verify "$..statusCode" contains text "202"

    #   Below Code is used to recursive to confirm status is changed from Accepted to Created
    Given I set endpoint as "<--config.props/BASE_URI_DUAL_TO_SEQUL" with API "/sequel/status/" along with "<--message.txt/Declaration_MessageID"
    And I add request header "Authorization" as "Bearer <--Oauth.txt/Token"
    And I add request header "Content-Type" as "<--config.props/CONTENT-TYPE"
    And I add request header "Ocp-Apim-Subscription-Key" as "<--config.props/OCP-APIM-SUBSCRIPTION-KEY"
    And Verify status is changed to Accepted from Created
    And I verify "$..status" contains text "Created"
    And I verify "$..statusCode" contains text "201"
    And I print response
    And I save response to "CreatedResponse.txt/DeclarationCreatedResponse"

    #    Below Code for is used to Fetch PolicyRef NUmber using Sequel Shared API's
    Then Fetch Policy Ref from PolicyId Received from status Outcome
    And I save value "$..policyRef-->ID.txt/PolicyRefID"

    #    Create Premium for above Declaration .
    Given I set endpoint as "<--config.props/BASE_URI_DUAL_TO_SEQUL" with API "/sequel/premium"
    And I add request header "Authorization" as "Bearer <--Oauth.txt/Token"
    And I add request header "Content-Type" as "<--config.props/CONTENT-TYPE"
    And I add request header "Ocp-Apim-Subscription-Key" as "<--config.props/OCP-APIM-SUBSCRIPTION-KEY"
    When I use json template "data/payload/DualToSequl/Premium.json"
    And I mention "$..PolicyRef" as "<--ID.txt/PolicyRefID"
    And I mention "$..insuredOrg" as "Test Insured <--TimeStamp.txt/timestamp"
    And I mention "$..transactionDate" as "<--TimeStamp.txt/transactionDate"
    And I mention "$..AsAtDate" as "<--TimeStamp.txt/AsAtDate"
    And I mention "$..clientSettDueDate" as "<--TimeStamp.txt/clientSettDueDate"
    And I mention "$..UWSettDueDate" as "<--TimeStamp.txt/UWSettDueDate"
    And I mention "$..transType" as "<PremiumType>"

    And I print request
    And I wait for "2" seconds

    #    Below Code will invoke Post API call and create Premium for Declaration
    Then I invoke the POST API with json payload
    And I print response
    And I save response to "Response.txt/PremiumResponse"
    And I save value "$..messageId-->message.txt/Premium_MessageID"
    And I print from file "<--Response.txt/PremiumResponse"
    And I wait for "2" seconds

    #    Below code will fetch Request ID and Assert Status Code and Created.
    Given I set endpoint as "<--config.props/BASE_URI_DUAL_TO_SEQUL" with API "/sequel/status/" along with "<--message.txt/Premium_MessageID"
    And I add request header "Authorization" as "Bearer <--Oauth.txt/Token"
    And I add request header "Content-Type" as "<--config.props/CONTENT-TYPE"
    And I add request header "Ocp-Apim-Subscription-Key" as "<--config.props/OCP-APIM-SUBSCRIPTION-KEY"
    And I print request
    Then I invoke the GET API
    And I print response

#    Below Code is used to recursive to confirm status is changed from Accepted to Created
    Given I set endpoint as "<--config.props/BASE_URI_DUAL_TO_SEQUL" with API "/sequel/status/" along with "<--message.txt/Premium_MessageID"
    And I add request header "Authorization" as "Bearer <--Oauth.txt/Token"
    And I add request header "Content-Type" as "<--config.props/CONTENT-TYPE"
    And I add request header "Ocp-Apim-Subscription-Key" as "<--config.props/OCP-APIM-SUBSCRIPTION-KEY"
    And Verify status is changed to Accepted from Created
    And I save response to "CreatedResponse.txt/PremiumCreatedResponse"
    And I verify "$..status" contains text "Created"
    And I verify "$..statusCode" contains text "201"
    And I print response


    Examples:
      | PremiumType |
      | PRM |
#      | AP |
#      | RPM |

  @smoke  @Premium  @Phase2
  Scenario Outline: Execute Premium Transaction API with different set of PPType as present in Excel .
    #    Test Case id in Azure Devops 10050

    #    Create Declaration in Dual Services
    #    Create Oauth Token and write to File
    Given I set endpoint as "<--config.props/BASE_URI_DUAL_TO_SEQUL" with API "/sequel/declaration"
    And I set Oauth Header with "<--config.props/DualToSequel_ID" and "<--config.props/DualToSequel_Secret" and "<--config.props/DualToSequel_Scope" and "<--config.props/DualToSequel_grant_type" and "<--config.props/DualToSequel_URL"
    And I print response
    And I save value "$..access_token-->Oauth.txt/Token"
    And I add request header "Authorization" as "Bearer <--Oauth.txt/Token"
    And I add request header "Content-Type" as "<--config.props/CONTENT-TYPE"
    And I add request header "Ocp-Apim-Subscription-Key" as "<--config.props/OCP-APIM-SUBSCRIPTION-KEY"
    When I use json template "data/payload/DualToSequl/Declaration.json"
    And I mention "$..policyDsc" as "A_Premium_PPType_$$timeStamp"
    And I mention "$..inceptionDate" as "<--TimeStamp.txt/inceptionDate"
    And I mention "$..expiryDate" as "<--TimeStamp.txt/expiryDate"

    And I mention "$.message.orgs[1].name" as "Test Insured <--TimeStamp.txt/timestamp"
    And I mention "$.message.orgs[1].org.orgNames[0].name" as "Test Insured <--TimeStamp.txt/timestamp"
    And I mention "$..roleDsc" as "Test Insured <--TimeStamp.txt/timestamp"
    And I print request

    #    Below Code will invoke Post API call and create Declaration in Eclipse
    Then I invoke the POST API with json payload
    And I print response
    And I save response to "Response.txt/DeclarationResponse"
    And I save value "$..messageId-->Message.txt/Declaration_MessageID"
    And I print from file "<--message.txt/Declaration_MessageID"
    And I wait for "2" seconds


    #    Below code will fetch Request ID and Assert Status Code and Created.
    Given I set endpoint as "<--config.props/BASE_URI_DUAL_TO_SEQUL" with API "/sequel/status/" along with "<--message.txt/Declaration_MessageID"
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
    Given I set endpoint as "<--config.props/BASE_URI_DUAL_TO_SEQUL" with API "/sequel/status/" along with "<--message.txt/Declaration_MessageID"
    And I add request header "Authorization" as "Bearer <--Oauth.txt/Token"
    And I add request header "Content-Type" as "<--config.props/CONTENT-TYPE"
    And I add request header "Ocp-Apim-Subscription-Key" as "<--config.props/OCP-APIM-SUBSCRIPTION-KEY"
    And Verify status is changed to Accepted from Created
    And I verify "$..status" contains text "Created"
    And I verify "$..statusCode" contains text "201"
    And I print response
    And I save response to "CreatedResponse.txt/DeclarationCreatedResponse"

    #Below Code for is used to Fetch PolicyRef NUmber using Sequel Shared API's
    Then Fetch Policy Ref from PolicyId Received from status Outcome
    And I save value "$..policyRef-->ID.txt/PolicyRefID"

    #    Create Premium for above Declaration .
    Given I set endpoint as "<--config.props/BASE_URI_DUAL_TO_SEQUL" with API "/sequel/premium"
    And I add request header "Authorization" as "Bearer <--Oauth.txt/Token"
    And I add request header "Content-Type" as "<--config.props/CONTENT-TYPE"
    And I add request header "Ocp-Apim-Subscription-Key" as "<--config.props/OCP-APIM-SUBSCRIPTION-KEY"
    When I use json template "data/payload/DualToSequl/Premium.json"
    And I mention "$..PolicyRef" as "<--ID.txt/PolicyRefID"
    And I mention "$..insuredOrg" as "Test Insured <--TimeStamp.txt/timestamp"
    And I mention "$..transactionDate" as "<--TimeStamp.txt/transactionDate"
    And I mention "$..AsAtDate" as "<--TimeStamp.txt/AsAtDate"
    And I mention "$..clientSettDueDate" as "<--TimeStamp.txt/clientSettDueDate"
    And I mention "$..UWSettDueDate" as "<--TimeStamp.txt/UWSettDueDate"
    And I mention "$..PPType" as "<PPType>"

    And I print request
    And I wait for "2" seconds

    #    Below Code will invoke Post API call and create Premium for Declaration
    Then I invoke the POST API with json payload
    And I print response
    And I save response to "Response.txt/PremiumResponse"
    And I save value "$..messageId-->message.txt/Premium_MessageID"
    And I print from file "<--Response.txt/PremiumResponse"
    And I wait for "2" seconds

    #    Below code will fetch Request ID and Assert Status Code and Created.
    Given I set endpoint as "<--config.props/BASE_URI_DUAL_TO_SEQUL" with API "/sequel/status/" along with "<--message.txt/Premium_MessageID"
    And I add request header "Authorization" as "Bearer <--Oauth.txt/Token"
    And I add request header "Content-Type" as "<--config.props/CONTENT-TYPE"
    And I add request header "Ocp-Apim-Subscription-Key" as "<--config.props/OCP-APIM-SUBSCRIPTION-KEY"
    And I print request
    Then I invoke the GET API
    And I print response


    #    Below Code is used to recursive to confirm status is changed from Accepted to Created
    Given I set endpoint as "<--config.props/BASE_URI_DUAL_TO_SEQUL" with API "/sequel/status/" along with "<--message.txt/Premium_MessageID"
    And I add request header "Authorization" as "Bearer <--Oauth.txt/Token"
    And I add request header "Content-Type" as "<--config.props/CONTENT-TYPE"
    And I add request header "Ocp-Apim-Subscription-Key" as "<--config.props/OCP-APIM-SUBSCRIPTION-KEY"
    And Verify status is changed to Accepted from Created
    And I save response to "CreatedResponse.txt/PremiumCreatedResponse"
    And I verify "$..status" contains text "Created"
    And I verify "$..statusCode" contains text "201"
    And I print response


    Examples:
      | PPType |
      | None |

  @smoke  @Premium  @Phase2
  Scenario: Execute Premium Transaction API with invalid policy ref in Json and confirm Error is Thrown.
    #    Test Case id in Azure Devops 10045

    #    Create Oauth Token and write to File
    Given I set endpoint as "<--config.props/BASE_URI_DUAL_TO_SEQUL" with API "/sequel/declaration"
    And I set Oauth Header with "<--config.props/DualToSequel_ID" and "<--config.props/DualToSequel_Secret" and "<--config.props/DualToSequel_Scope" and "<--config.props/DualToSequel_grant_type" and "<--config.props/DualToSequel_URL"
    And I print response
    And I save value "$..access_token-->Oauth.txt/Token"

    #    Create Premium with Invalid Policy ref Number .
    Given I set endpoint as "<--config.props/BASE_URI_DUAL_TO_SEQUL" with API "/sequel/premium"
    And I add request header "Authorization" as "Bearer <--Oauth.txt/Token"
    And I add request header "Content-Type" as "<--config.props/CONTENT-TYPE"
    And I add request header "Ocp-Apim-Subscription-Key" as "<--config.props/OCP-APIM-SUBSCRIPTION-KEY"
    When I use json template "data/payload/DualToSequl/Premium.json"
    And I mention "$..PolicyRef" as "1231231"

    And I print request
    And I wait for "2" seconds

    #    Below Code will invoke Post API call and create Premium for Declaration
    Then I invoke the POST API with json payload
    And I print response
    And I save response to "Response.txt/PremiumResponse"
    And I save value "$..messageId-->message.txt/Premium_MessageID"
    And I print from file "<--Response.txt/PremiumResponse"
    And I wait for "2" seconds

    #    Below code will fetch Request ID and Assert Status Code and Created.
    Given I set endpoint as "<--config.props/BASE_URI_DUAL_TO_SEQUL" with API "/sequel/status/" along with "<--message.txt/Premium_MessageID"
    And I add request header "Authorization" as "Bearer <--Oauth.txt/Token"
    And I add request header "Content-Type" as "<--config.props/CONTENT-TYPE"
    And I add request header "Ocp-Apim-Subscription-Key" as "<--config.props/OCP-APIM-SUBSCRIPTION-KEY"
    And I print request
    Then I invoke the GET API
    And I print response
    And I verify the status code to be "200"
    #    And I verify "$..status" contains text "Accepted"
    And I verify "$..statusCode" contains text "400"

  @smoke  @Premium  @Phase2
  Scenario: Execute Premium Transaction API without policy ref in Json and confirm Error is Thrown.
    #    Test Case id in Azure Devops 10044

    #    Create Oauth Token and write to File
    Given I set endpoint as "<--config.props/BASE_URI_DUAL_TO_SEQUL" with API "/sequel/declaration"
    And I set Oauth Header with "<--config.props/DualToSequel_ID" and "<--config.props/DualToSequel_Secret" and "<--config.props/DualToSequel_Scope" and "<--config.props/DualToSequel_grant_type" and "<--config.props/DualToSequel_URL"
    And I print response
    And I save value "$..access_token-->Oauth.txt/Token"

    #    Create Premium with Invalid Policy ref Number .
    Given I set endpoint as "<--config.props/BASE_URI_DUAL_TO_SEQUL" with API "/sequel/premium"
    And I add request header "Authorization" as "Bearer <--Oauth.txt/Token"
    And I add request header "Content-Type" as "<--config.props/CONTENT-TYPE"
    And I add request header "Ocp-Apim-Subscription-Key" as "<--config.props/OCP-APIM-SUBSCRIPTION-KEY"
    When I use json template "data/payload/DualToSequl/Premium.json"
    And I mention "$..PolicyRef" as ""

    And I print request
    And I wait for "2" seconds

    #    Below Code will invoke Post API call and create Premium for Declaration
    Then I invoke the POST API with json payload
    And I print response
    And I save response to "Response.txt/PremiumResponse"
    And I save value "$..messageId-->message.txt/Premium_MessageID"
    And I print from file "<--Response.txt/PremiumResponse"
    And I wait for "2" seconds

    #    Below code will fetch Request ID and Assert Status Code and Created.
    Given I set endpoint as "<--config.props/BASE_URI_DUAL_TO_SEQUL" with API "/sequel/status/" along with "<--message.txt/Premium_MessageID"
    And I add request header "Authorization" as "Bearer <--Oauth.txt/Token"
    And I add request header "Content-Type" as "<--config.props/CONTENT-TYPE"
    And I add request header "Ocp-Apim-Subscription-Key" as "<--config.props/OCP-APIM-SUBSCRIPTION-KEY"
    And I print request
    Then I invoke the GET API
    And I print response
    And I verify the status code to be "400"
    #    And I verify "$..status" contains text "Accepted"
    And I verify "$..code" contains text "400"
    And I verify "$..message" contains text "Object contained invalid properties - check policy ref / section code"

  @smoke  @Premium  @Phase2
  Scenario Outline: Execute Premium Transaction API with authoriseAndPost parameter as True & False. When True Verify Premium trans is authorized and  Posted
    #    Test Case id in Azure Devops 10051

    #    Create Declaration in Dual Services
    Given I set endpoint as "<--config.props/BASE_URI_DUAL_TO_SEQUL" with API "/sequel/declaration"
    And I set Oauth Header with "<--config.props/DualToSequel_ID" and "<--config.props/DualToSequel_Secret" and "<--config.props/DualToSequel_Scope" and "<--config.props/DualToSequel_grant_type" and "<--config.props/DualToSequel_URL"
    And I print response
    And I save value "$..access_token-->Oauth.txt/Token"
    And I add request header "Authorization" as "Bearer <--Oauth.txt/Token"
    And I add request header "Content-Type" as "<--config.props/CONTENT-TYPE"
    And I add request header "Ocp-Apim-Subscription-Key" as "<--config.props/OCP-APIM-SUBSCRIPTION-KEY"
    When I use json template "data/payload/DualToSequl/Declaration.json"
    And I mention "$..policyDsc" as "A_Premium_authoriseAndPost_$$timeStamp"
    And I mention "$..inceptionDate" as "<--TimeStamp.txt/inceptionDate"
    And I mention "$..expiryDate" as "<--TimeStamp.txt/expiryDate"

    And I mention "$.message.orgs[1].name" as "Test Insured <--TimeStamp.txt/timestamp"
    And I mention "$.message.orgs[1].org.orgNames[0].name" as "Test Insured <--TimeStamp.txt/timestamp"
    And I mention "$..roleDsc" as "Test Insured <--TimeStamp.txt/timestamp"
#    And add "KeyNewField" as "ValueNewField" to "$.message"
    And I print request

    #    Below Code will invoke Post API call and create Declaration in Eclipse
    Then I invoke the POST API with json payload
    And I print response
    And I save response to "Response.txt/DeclarationResponse"
    And I save value "$..messageId-->Message.txt/Declaration_MessageID"
    And I print from file "<--message.txt/Declaration_MessageID"
    And I wait for "2" seconds


    #    Below code will fetch Request ID and Assert Status Code and Created.
    Given I set endpoint as "<--config.props/BASE_URI_DUAL_TO_SEQUL" with API "/sequel/status/" along with "<--message.txt/Declaration_MessageID"
    And I add request header "Authorization" as "Bearer <--Oauth.txt/Token"
    And I add request header "Content-Type" as "<--config.props/CONTENT-TYPE"
    And I add request header "Ocp-Apim-Subscription-Key" as "<--config.props/OCP-APIM-SUBSCRIPTION-KEY"
    And I print request
    Then I invoke the GET API
    And I print response
    And I verify the status code to be "200"
    And I verify "$..status" contains text "Accepted"
    And I verify "$..statusCode" contains text "202"

    #   Below Code is used to recursive to confirm status is changed from Accepted to Created
    Given I set endpoint as "<--config.props/BASE_URI_DUAL_TO_SEQUL" with API "/sequel/status/" along with "<--message.txt/Declaration_MessageID"
    And I add request header "Authorization" as "Bearer <--Oauth.txt/Token"
    And I add request header "Content-Type" as "<--config.props/CONTENT-TYPE"
    And I add request header "Ocp-Apim-Subscription-Key" as "<--config.props/OCP-APIM-SUBSCRIPTION-KEY"
    And Verify status is changed to Accepted from Created
    And I verify "$..status" contains text "Created"
    And I verify "$..statusCode" contains text "201"
    And I print response
    And I save response to "CreatedResponse.txt/DeclarationCreatedResponse"

    #    Below Code for is used to Fetch PolicyRef NUmber using Sequel Shared API's
    Then Fetch Policy Ref from PolicyId Received from status Outcome
    And I save value "$..policyRef-->ID.txt/PolicyRefID"

    #    Create Premium for above Declaration .
    Given I set endpoint as "<--config.props/BASE_URI_DUAL_TO_SEQUL" with API "/sequel/premium"
    And I add request header "Authorization" as "Bearer <--Oauth.txt/Token"
    And I add request header "Content-Type" as "<--config.props/CONTENT-TYPE"
    And I add request header "Ocp-Apim-Subscription-Key" as "<--config.props/OCP-APIM-SUBSCRIPTION-KEY"
    When I use json template "data/payload/DualToSequl/Premium.json"
    And I mention "$..PolicyRef" as "<--ID.txt/PolicyRefID"
    And I mention "$..insuredOrg" as "Test Insured <--TimeStamp.txt/timestamp"
    And I mention "$..authoriseAndPost" as "<AuthoriseAndPost>"
    And I mention "$..transactionDate" as "<--TimeStamp.txt/transactionDate"
    And I mention "$..AsAtDate" as "<--TimeStamp.txt/AsAtDate"
    And I mention "$..clientSettDueDate" as "<--TimeStamp.txt/clientSettDueDate"
    And I mention "$..UWSettDueDate" as "<--TimeStamp.txt/UWSettDueDate"

    And I print request
    And I wait for "2" seconds

    #    Below Code will invoke Post API call and create Premium for Declaration
    Then I invoke the POST API with json payload
    And I print response
    And I save response to "Response.txt/PremiumResponse"
    And I save value "$..messageId-->message.txt/Premium_MessageID"
    And I print from file "<--Response.txt/PremiumResponse"
    And I wait for "2" seconds

    #    Below code will fetch Request ID and Assert Status Code and Created.
    Given I set endpoint as "<--config.props/BASE_URI_DUAL_TO_SEQUL" with API "/sequel/status/" along with "<--message.txt/Premium_MessageID"
    And I add request header "Authorization" as "Bearer <--Oauth.txt/Token"
    And I add request header "Content-Type" as "<--config.props/CONTENT-TYPE"
    And I add request header "Ocp-Apim-Subscription-Key" as "<--config.props/OCP-APIM-SUBSCRIPTION-KEY"
    And I print request
    Then I invoke the GET API
    And I print response

#    Below Code is used to recursive to confirm status is changed from Accepted to Created
    Given I set endpoint as "<--config.props/BASE_URI_DUAL_TO_SEQUL" with API "/sequel/status/" along with "<--message.txt/Premium_MessageID"
    And I add request header "Authorization" as "Bearer <--Oauth.txt/Token"
    And I add request header "Content-Type" as "<--config.props/CONTENT-TYPE"
    And I add request header "Ocp-Apim-Subscription-Key" as "<--config.props/OCP-APIM-SUBSCRIPTION-KEY"
    And Verify status is changed to Accepted from Created
    And I save response to "CreatedResponse.txt/PremiumCreatedResponse"
    And I verify "$..status" contains text "Created"
    And I verify "$..statusCode" contains text "201"
    And I print response


    Examples:
      | AuthoriseAndPost |
      | true |
      | false |


  @Test
  Scenario: Test
    #    Test Case id in Azure Devops 10051

    #    Create Declaration in Dual Services
#    And I print given value "$$rndString"
    #    Create MTA without any changes for above Declaration .
    Given I set endpoint as "<--config.props/BASE_URI_DUAL_TO_SEQUL" with API "/sequel/mta"
#    And I add request header "Authorization" as "Bearer <--Oauth.txt/Token"
#    And I add request header "Content-Type" as "<--config.props/CONTENT-TYPE"
#    And I add request header "Ocp-Apim-Subscription-Key" as "<--config.props/OCP-APIM-SUBSCRIPTION-KEY"
    When I use json template "data/payload/DualToSequl/hcMTABasic.json"
    And I mention "$..policyRef" as "<--ID.txt/PolicyRefID"
    And I Remove "$..effectiveDate" from Json
    And I Remove "$..policyDetails" from Json
#    And I mention "$..effectiveDate" as "<--TimeStamp.txt/effectiveDate"
#    And I mention "$..policyDsc" as "A_HC_NO_MTA_<--TimeStamp.txt/timestamp"

    And I print request
    And I wait for "2" seconds

#    #    Below Code will invoke Post API call and update MTA for  Declaration
#    Then I invoke the POST API with json payload
#    And I print response
#    And I save response to "Response.txt/MTAResponse"
#    And I save value "$..messageId-->message.txt/MTA_MessageID"
#    And I print from file "<--Response.txt/MTAResponse"
#    And I wait for "2" seconds

#  And I print "<string>"
#    And I print "String"