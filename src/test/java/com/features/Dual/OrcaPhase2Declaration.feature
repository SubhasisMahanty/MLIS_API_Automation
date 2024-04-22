Feature: Dual: API Phase 2 Test ORCA Declaration

  @smoke  @Declaration  @Phase2   @Orca
  Scenario: Create Orca Declaration with out policy reference number and confirm works Fine.
    #    Test Case id in Azure Devops 10354

    #    Create Declaration in Dual Services Orca
    Given I set endpoint as "<--config.props/BASE_URI_DUAL_TO_SEQUL" with API "/sequel/declaration"
    And I set Oauth Header with "<--config.props/DualToSequel_ID" and "<--config.props/DualToSequel_Secret" and "<--config.props/DualToSequel_Scope" and "<--config.props/DualToSequel_grant_type" and "<--config.props/DualToSequel_URL"
    And I print response
    And I save value "$..access_token-->Oauth.txt/Token"
    And I add request header "Authorization" as "Bearer <--Oauth.txt/Token"
    And I add request header "Content-Type" as "<--config.props/CONTENT-TYPE"
    And I add request header "Ocp-Apim-Subscription-Key" as "<--config.props/OCP-APIM-SUBSCRIPTION-KEY"
    When I use json template "data/payload/DualToSequl/orcaDeclaration.json"
    And I mention "$..policyDsc" as "A_Orca_Decl_Nopolicy_$$timeStamp"
    And I mention "$..inceptionDate" as "<--TimeStamp.txt/inceptionDate"
    And I mention "$..expiryDate" as "<--TimeStamp.txt/expiryDate"

#    And I mention "$.message.orgs[1].name" as "Test Insured <--TimeStamp.txt/timestamp"
#    And I mention "$.message.orgs[1].org.orgNames[0].name" as "Test Insured <--TimeStamp.txt/timestamp"
#    And I mention "$..roleDsc" as "Test Insured <--TimeStamp.txt/timestamp"
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



  @smoke  @Declaration  @Phase2 @Orca
  Scenario: Create Orca Declaration with invalid json structure.
    #    Test Case id in Azure Devops 10356

    #    Create Declaration in Dual Services Orca
    Given I set endpoint as "<--config.props/BASE_URI_DUAL_TO_SEQUL" with API "/sequel/declaration"
    And I set Oauth Header with "<--config.props/DualToSequel_ID" and "<--config.props/DualToSequel_Secret" and "<--config.props/DualToSequel_Scope" and "<--config.props/DualToSequel_grant_type" and "<--config.props/DualToSequel_URL"
    And I print response
    And I save value "$..access_token-->Oauth.txt/Token"
    And I add request header "Authorization" as "Bearer <--Oauth.txt/Token"
    And I add request header "Content-Type" as "<--config.props/CONTENT-TYPE"
    And I add request header "Ocp-Apim-Subscription-Key" as "<--config.props/OCP-APIM-SUBSCRIPTION-KEY"
    When I use json template "data/payload/DualToSequl/orcaDeclaration.json"
    And I mention "$..policyDsc" as "A_Orca_Decl_invalidjson_$$timeStamp"
    And I mention "$..inceptionDate" as "<--TimeStamp.txt/inceptionDate"
    And I mention "$..expiryDate" as "<--TimeStamp.txt/expiryDate"
    And I Add "invalid" as "content" to "$.message"
    And I Remove "$.message" from Json
#        And add "KeyNewField" as "ValueNewField" to "$.message"
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
    And I verify the status code to be "400"
    And I verify "$..code" contains text "400"

  @smoke  @Declaration  @Phase2 @Orca
  Scenario: Create Orca Declaration with new Insured is passed as part of Json.
    #    Test Case id in Azure Devops 10358

    #    Create Declaration in Dual Services Orca
    Given I set endpoint as "<--config.props/BASE_URI_DUAL_TO_SEQUL" with API "/sequel/declaration"
    And I set Oauth Header with "<--config.props/DualToSequel_ID" and "<--config.props/DualToSequel_Secret" and "<--config.props/DualToSequel_Scope" and "<--config.props/DualToSequel_grant_type" and "<--config.props/DualToSequel_URL"
    And I print response
    And I save value "$..access_token-->Oauth.txt/Token"
    And I add request header "Authorization" as "Bearer <--Oauth.txt/Token"
    And I add request header "Content-Type" as "<--config.props/CONTENT-TYPE"
    And I add request header "Ocp-Apim-Subscription-Key" as "<--config.props/OCP-APIM-SUBSCRIPTION-KEY"
    When I use json template "data/payload/DualToSequl/orcaDeclaration.json"
    And I mention "$..policyDsc" as "A_Orca_Decl_newInsured_$$timeStamp"
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



  @smoke  @Declaration  @Phase2 @Orca
  Scenario: Create Orca Declaration with with multiple handlers as part of Json.
    #    Test Case id in Azure Devops 10359

    #    Create Declaration in Dual Services Orca
    Given I set endpoint as "<--config.props/BASE_URI_DUAL_TO_SEQUL" with API "/sequel/declaration"
    And I set Oauth Header with "<--config.props/DualToSequel_ID" and "<--config.props/DualToSequel_Secret" and "<--config.props/DualToSequel_Scope" and "<--config.props/DualToSequel_grant_type" and "<--config.props/DualToSequel_URL"
    And I print response
    And I save value "$..access_token-->Oauth.txt/Token"
    And I add request header "Authorization" as "Bearer <--Oauth.txt/Token"
    And I add request header "Content-Type" as "<--config.props/CONTENT-TYPE"
    And I add request header "Ocp-Apim-Subscription-Key" as "<--config.props/OCP-APIM-SUBSCRIPTION-KEY"
    When I use json template "data/payload/DualToSequl/orcaMultipleHandlersDeclaration.json"
    And I mention "$..policyDsc" as "A_Orca_Decl_MulHandlr_$$timeStamp"
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


  @smoke  @Declaration  @Phase2   @Orca
  Scenario: Create Orca Declaration with "inheritDeductionsAndTaxes": true
    #    Test Case id in Azure Devops 10360

    #    Create Declaration in Dual Services Orca
    Given I set endpoint as "<--config.props/BASE_URI_DUAL_TO_SEQUL" with API "/sequel/declaration"
    And I set Oauth Header with "<--config.props/DualToSequel_ID" and "<--config.props/DualToSequel_Secret" and "<--config.props/DualToSequel_Scope" and "<--config.props/DualToSequel_grant_type" and "<--config.props/DualToSequel_URL"
    And I print response
    And I save value "$..access_token-->Oauth.txt/Token"
    And I add request header "Authorization" as "Bearer <--Oauth.txt/Token"
    And I add request header "Content-Type" as "<--config.props/CONTENT-TYPE"
    And I add request header "Ocp-Apim-Subscription-Key" as "<--config.props/OCP-APIM-SUBSCRIPTION-KEY"
    When I use json template "data/payload/DualToSequl/orcaDeclaration.json"
    And I mention "$..policyDsc" as "A_Orca_Decl_TaxAsTRUE_$$timeStamp"
    And I mention "$..inceptionDate" as "<--TimeStamp.txt/inceptionDate"
    And I mention "$..expiryDate" as "<--TimeStamp.txt/expiryDate"

    And I mention "$.message.orgs[1].name" as "Test Insured <--TimeStamp.txt/timestamp"
    And I mention "$.message.orgs[1].org.orgNames[0].name" as "Test Insured <--TimeStamp.txt/timestamp"
    And I mention "$..roleDsc" as "Test Insured <--TimeStamp.txt/timestamp"
    And I mention "$..inheritDeductionsAndTaxes" as "true"
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


