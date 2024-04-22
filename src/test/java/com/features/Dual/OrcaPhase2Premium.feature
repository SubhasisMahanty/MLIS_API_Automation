Feature: Dual: API Phase 2 Test ORCA Premium

  @smoke @Premium @Phase2
  Scenario Outline: Execute ORCA Premium Transaction API with different set of transType as present in Excel
    #    Test Case id in Azure Devops 10229
    #    Create Declaration in Dual Services
    Given I set endpoint as "<--config.props/BASE_URI_DUAL_TO_SEQUL" with API "/sequel/declaration"
    And I set Oauth Header with "<--config.props/DualToSequel_ID" and "<--config.props/DualToSequel_Secret" and "<--config.props/DualToSequel_Scope" and "<--config.props/DualToSequel_grant_type" and "<--config.props/DualToSequel_URL"
    And I print response
    And I save value "$..access_token-->Oauth.txt/Token"
    And I add request header "Authorization" as "Bearer <--Oauth.txt/Token"
    And I add request header "Content-Type" as "<--config.props/CONTENT-TYPE"
    And I add request header "Ocp-Apim-Subscription-Key" as "<--config.props/OCP-APIM-SUBSCRIPTION-KEY"
    When I use json template "data/payload/DualToSequl/orcaDeclaration.json"
    And I mention "$..policyDsc" as "A_Orca_Prm_transType_$$timeStamp"
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
    When I use json template "data/payload/DualToSequl/orcaPremium.json"
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
    And I wait for "2" seconds
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
      | PRM         |

  #      | AP |
  #      | RPM |
  @smoke @Premium @Phase2
  Scenario Outline: Execute ORCA Premium Transaction API with different set of PPType as present in Excel .
    #    Test Case id in Azure Devops 10233
    #    Create Declaration in Dual Services
    #    Create Oauth Token and write to File
    Given I set endpoint as "<--config.props/BASE_URI_DUAL_TO_SEQUL" with API "/sequel/declaration"
    And I set Oauth Header with "<--config.props/DualToSequel_ID" and "<--config.props/DualToSequel_Secret" and "<--config.props/DualToSequel_Scope" and "<--config.props/DualToSequel_grant_type" and "<--config.props/DualToSequel_URL"
    And I print response
    And I save value "$..access_token-->Oauth.txt/Token"
    And I add request header "Authorization" as "Bearer <--Oauth.txt/Token"
    And I add request header "Content-Type" as "<--config.props/CONTENT-TYPE"
    And I add request header "Ocp-Apim-Subscription-Key" as "<--config.props/OCP-APIM-SUBSCRIPTION-KEY"
    When I use json template "data/payload/DualToSequl/orcaDeclaration.json"
    And I mention "$..policyDsc" as "A_Orca_Prm_PPType_$$timeStamp"
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
    And I wait for "2" seconds
    #Below Code for is used to Fetch PolicyRef NUmber using Sequel Shared API's
    Then Fetch Policy Ref from PolicyId Received from status Outcome
    And I save value "$..policyRef-->ID.txt/PolicyRefID"
    #    Create Premium for above Declaration .
    Given I set endpoint as "<--config.props/BASE_URI_DUAL_TO_SEQUL" with API "/sequel/premium"
    And I add request header "Authorization" as "Bearer <--Oauth.txt/Token"
    And I add request header "Content-Type" as "<--config.props/CONTENT-TYPE"
    And I add request header "Ocp-Apim-Subscription-Key" as "<--config.props/OCP-APIM-SUBSCRIPTION-KEY"
    When I use json template "data/payload/DualToSequl/orcaPremium.json"
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
    And I wait for "2" seconds
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
      | None   |

  @smoke @Premium @Phase2
  Scenario: Execute ORCA Premium Transaction API with invalid policy ref in Json and confirm Error is Thrown.
    #    Test Case id in Azure Devops 10228
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
    When I use json template "data/payload/DualToSequl/orcaPremium.json"
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

  @smoke @Premium @Phase2
  Scenario: Execute ORCA Premium Transaction API without policy ref in Json and confirm Error is Thrown.
    #    Test Case id in Azure Devops 10227
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
    When I use json template "data/payload/DualToSequl/orcaPremium.json"
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

  @smoke @Premium @Phase2
  Scenario Outline: Execute ORCA Premium Transaction API with authoriseAndPost parameter as True & False. When True Verify Premium trans is authorized and  Posted
    #    Test Case id in Azure Devops 10234
    #    Create Declaration in Dual Services
    Given I set endpoint as "<--config.props/BASE_URI_DUAL_TO_SEQUL" with API "/sequel/declaration"
    And I set Oauth Header with "<--config.props/DualToSequel_ID" and "<--config.props/DualToSequel_Secret" and "<--config.props/DualToSequel_Scope" and "<--config.props/DualToSequel_grant_type" and "<--config.props/DualToSequel_URL"
    And I print response
    And I save value "$..access_token-->Oauth.txt/Token"
    And I add request header "Authorization" as "Bearer <--Oauth.txt/Token"
    And I add request header "Content-Type" as "<--config.props/CONTENT-TYPE"
    And I add request header "Ocp-Apim-Subscription-Key" as "<--config.props/OCP-APIM-SUBSCRIPTION-KEY"
    When I use json template "data/payload/DualToSequl/orcaDeclaration.json"
    And I mention "$..policyDsc" as "A_Orca_Prm_authoriseAndPost_$$timeStamp"
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
    When I use json template "data/payload/DualToSequl/orcaPremium.json"
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
    And I wait for "2" seconds
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
      | true             |
      | false            |

  @smoke @Premium @Phase2
  Scenario Outline: Execute Premium Transaction API for different BillingCcyISO currency eg (EUR , GBP ,USD)
    #    Test Case id in Azure Devops 10231
    #    Create Declaration in Dual Services
    Given I set endpoint as "<--config.props/BASE_URI_DUAL_TO_SEQUL" with API "/sequel/declaration"
    And I set Oauth Header with "<--config.props/DualToSequel_ID" and "<--config.props/DualToSequel_Secret" and "<--config.props/DualToSequel_Scope" and "<--config.props/DualToSequel_grant_type" and "<--config.props/DualToSequel_URL"
    And I print response
    And I save value "$..access_token-->Oauth.txt/Token"
    And I add request header "Authorization" as "Bearer <--Oauth.txt/Token"
    And I add request header "Content-Type" as "<--config.props/CONTENT-TYPE"
    And I add request header "Ocp-Apim-Subscription-Key" as "<--config.props/OCP-APIM-SUBSCRIPTION-KEY"
    When I use json template "data/payload/DualToSequl/orcaDeclaration.json"
    And I mention "$..policyDsc" as "A_Orca_Prm_BillingCcyISO_$$timeStamp"
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
    When I use json template "data/payload/DualToSequl/orcaPremium.json"
    And I mention "$..PolicyRef" as "<--ID.txt/PolicyRefID"
    And I mention "$..insuredOrg" as "Test Insured <--TimeStamp.txt/timestamp"
    And I mention "$..BillingCcyISO" as "<BillingCcyISO>"
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
    And I wait for "2" seconds
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
      | BillingCcyISO |
      | EUR           |
      | GBP           |
      | USD           |

  @smoke @Premium @Phase2
  Scenario: Execute Premium transaction API with Transdate and Asdate values.
    #    Test Case id in Azure Devops 10238
    #    Create Declaration in Dual Services
    Given I set endpoint as "<--config.props/BASE_URI_DUAL_TO_SEQUL" with API "/sequel/declaration"
    And I set Oauth Header with "<--config.props/DualToSequel_ID" and "<--config.props/DualToSequel_Secret" and "<--config.props/DualToSequel_Scope" and "<--config.props/DualToSequel_grant_type" and "<--config.props/DualToSequel_URL"
    And I print response
    And I save value "$..access_token-->Oauth.txt/Token"
    And I add request header "Authorization" as "Bearer <--Oauth.txt/Token"
    And I add request header "Content-Type" as "<--config.props/CONTENT-TYPE"
    And I add request header "Ocp-Apim-Subscription-Key" as "<--config.props/OCP-APIM-SUBSCRIPTION-KEY"
    When I use json template "data/payload/DualToSequl/orcaDeclaration.json"
    And I mention "$..policyDsc" as "A_Orca_Prm_Tras&As_$$timeStamp"
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
    When I use json template "data/payload/DualToSequl/orcaPremium.json"
    And I mention "$..PolicyRef" as "<--ID.txt/PolicyRefID"
    And I mention "$..insuredOrg" as "Test Insured <--TimeStamp.txt/timestamp"
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
    And I wait for "2" seconds
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

  @smoke @Premium @Phase2
  Scenario: Execute Premium Transaction API with riskCode parameter try with different RiskCode Combination.
    #    Test Case id in Azure Devops 10235
    #    Create Declaration in Dual Services
    Given I set endpoint as "<--config.props/BASE_URI_DUAL_TO_SEQUL" with API "/sequel/declaration"
    And I set Oauth Header with "<--config.props/DualToSequel_ID" and "<--config.props/DualToSequel_Secret" and "<--config.props/DualToSequel_Scope" and "<--config.props/DualToSequel_grant_type" and "<--config.props/DualToSequel_URL"
    And I print response
    And I save value "$..access_token-->Oauth.txt/Token"
    And I add request header "Authorization" as "Bearer <--Oauth.txt/Token"
    And I add request header "Content-Type" as "<--config.props/CONTENT-TYPE"
    And I add request header "Ocp-Apim-Subscription-Key" as "<--config.props/OCP-APIM-SUBSCRIPTION-KEY"
    When I use json template "data/payload/DualToSequl/orcaDeclaration.json"
    And I mention "$..policyDsc" as "A_Orca_Prm_RiskCode_$$timeStamp"
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
    When I use json template "data/payload/DualToSequl/orcaPremium.json"
    And I mention "$..PolicyRef" as "<--ID.txt/PolicyRefID"
    And I mention "$..insuredOrg" as "Test Insured <--TimeStamp.txt/timestamp"
    And I mention "$..transactionDate" as "<--TimeStamp.txt/transactionDate"
    And I mention "$..AsAtDate" as "<--TimeStamp.txt/AsAtDate"
    And I mention "$..clientSettDueDate" as "<--TimeStamp.txt/clientSettDueDate"
    And I mention "$..UWSettDueDate" as "<--TimeStamp.txt/UWSettDueDate"
    And I mention "$..riskCode" as "XT"
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
    And I wait for "2" seconds
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

  @smoke @Premium @Phase2
  Scenario: Execute Premium Transaction API transactionDate Date prior to Policy Create Date . And Verify it Fails, try Combination with future Date as well
    #    Test Case id in Azure Devops 10230
    #    Create Declaration in Dual Services
    Given I set endpoint as "<--config.props/BASE_URI_DUAL_TO_SEQUL" with API "/sequel/declaration"
    And I set Oauth Header with "<--config.props/DualToSequel_ID" and "<--config.props/DualToSequel_Secret" and "<--config.props/DualToSequel_Scope" and "<--config.props/DualToSequel_grant_type" and "<--config.props/DualToSequel_URL"
    And I print response
    And I save value "$..access_token-->Oauth.txt/Token"
    And I add request header "Authorization" as "Bearer <--Oauth.txt/Token"
    And I add request header "Content-Type" as "<--config.props/CONTENT-TYPE"
    And I add request header "Ocp-Apim-Subscription-Key" as "<--config.props/OCP-APIM-SUBSCRIPTION-KEY"
    When I use json template "data/payload/DualToSequl/orcaDeclaration.json"
    And I mention "$..policyDsc" as "A_Orca_Prm_PriorTransDate_$$timeStamp"
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
    When I use json template "data/payload/DualToSequl/orcaPremium.json"
    And I mention "$..PolicyRef" as "<--ID.txt/PolicyRefID"
    And I mention "$..insuredOrg" as "Test Insured <--TimeStamp.txt/timestamp"
    And I mention "$..transactionDate" as "<--TimeStamp.txt/yesterdayTransactionDate"
    And I mention "$..AsAtDate" as "<--TimeStamp.txt/AsAtDate"
    And I mention "$..clientSettDueDate" as "<--TimeStamp.txt/clientSettDueDate"
    And I mention "$..UWSettDueDate" as "<--TimeStamp.txt/UWSettDueDate"
    And I mention "$..riskCode" as "XT"
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
    And I wait for "2" seconds
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
