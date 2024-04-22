Feature: Dual: API Phase 2 Test Health Care MTA alias Endorsement

  @smoke  @MTA  @Phase2
  Scenario: Create Declaration and Do MTA on top of That
    #    Test Case id in Azure Devops 10067

    #    Create Declaration in Dual Services
    Given I set endpoint as "<--config.props/BASE_URI_DUAL_TO_SEQUL" with API "/sequel/declaration"
    And I set Oauth Header with "<--config.props/DualToSequel_ID" and "<--config.props/DualToSequel_Secret" and "<--config.props/DualToSequel_Scope" and "<--config.props/DualToSequel_grant_type" and "<--config.props/DualToSequel_URL"
    And I print response
    And I save value "$..access_token-->Oauth.txt/Token"
    And I add request header "Authorization" as "Bearer <--Oauth.txt/Token"
    And I add request header "Content-Type" as "<--config.props/CONTENT-TYPE"
    And I add request header "Ocp-Apim-Subscription-Key" as "<--config.props/OCP-APIM-SUBSCRIPTION-KEY"
    When I use json template "data/payload/DualToSequl/Declaration.json"
    And I mention "$..policyDsc" as "A_HC_MTA_$$timeStamp"
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

    #    Create MTA for above Declaration .
    Given I set endpoint as "<--config.props/BASE_URI_DUAL_TO_SEQUL" with API "/sequel/mta"
    And I add request header "Authorization" as "Bearer <--Oauth.txt/Token"
    And I add request header "Content-Type" as "<--config.props/CONTENT-TYPE"
    And I add request header "Ocp-Apim-Subscription-Key" as "<--config.props/OCP-APIM-SUBSCRIPTION-KEY"
    When I use json template "data/payload/DualToSequl/hcMTABasic.json"
    And I mention "$..policyRef" as "<--ID.txt/PolicyRefID"
    And I mention "$..effectiveDate" as "<--TimeStamp.txt/effectiveDate"
    And I mention "$..policyDsc" as "Modified_A_HC_MTA_$$timeStamp"

    And I print request
    And I wait for "2" seconds

    #    Below Code will invoke Post API call and update MTA for  Declaration
    Then I invoke the POST API with json payload
    And I print response
    And I save response to "Response.txt/MTAResponse"
    And I save value "$..messageId-->message.txt/MTA_MessageID"
    And I print from file "<--Response.txt/MTAResponse"
    And I wait for "2" seconds

    #    Below code will fetch Request ID and Assert Status Code and Created.
    Given I set endpoint as "<--config.props/BASE_URI_DUAL_TO_SEQUL" with API "/sequel/status/" along with "<--message.txt/MTA_MessageID"
    And I add request header "Authorization" as "Bearer <--Oauth.txt/Token"
    And I add request header "Content-Type" as "<--config.props/CONTENT-TYPE"
    And I add request header "Ocp-Apim-Subscription-Key" as "<--config.props/OCP-APIM-SUBSCRIPTION-KEY"
    And I print request
    Then I invoke the GET API
    And I print response

#    Below Code is used to recursive to confirm status is changed from Accepted to Created
    Given I set endpoint as "<--config.props/BASE_URI_DUAL_TO_SEQUL" with API "/sequel/status/" along with "<--message.txt/MTA_MessageID"
    And I add request header "Authorization" as "Bearer <--Oauth.txt/Token"
    And I add request header "Content-Type" as "<--config.props/CONTENT-TYPE"
    And I add request header "Ocp-Apim-Subscription-Key" as "<--config.props/OCP-APIM-SUBSCRIPTION-KEY"
    And Verify status is changed to Accepted from Created
    And I save response to "CreatedResponse.txt/MTACreatedResponse"
    And I verify "$..status" contains text "Created"
    And I verify "$..statusCode" contains text "201"
    And I print response

  @smoke  @MTA  @Phase2
  Scenario: Try to do MTA for Premium associated with Declaration
    #    Test Case id in Azure Devops 10068

    #    Create Declaration in Dual Services
    Given I set endpoint as "<--config.props/BASE_URI_DUAL_TO_SEQUL" with API "/sequel/declaration"
    And I set Oauth Header with "<--config.props/DualToSequel_ID" and "<--config.props/DualToSequel_Secret" and "<--config.props/DualToSequel_Scope" and "<--config.props/DualToSequel_grant_type" and "<--config.props/DualToSequel_URL"
    And I print response
    And I save value "$..access_token-->Oauth.txt/Token"
    And I add request header "Authorization" as "Bearer <--Oauth.txt/Token"
    And I add request header "Content-Type" as "<--config.props/CONTENT-TYPE"
    And I add request header "Ocp-Apim-Subscription-Key" as "<--config.props/OCP-APIM-SUBSCRIPTION-KEY"
    When I use json template "data/payload/DualToSequl/Declaration.json"
    And I mention "$..policyDsc" as "A_HC_MTA_Prm_$$timeStamp"
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

    #    Create MTA for above Declaration .
    Given I set endpoint as "<--config.props/BASE_URI_DUAL_TO_SEQUL" with API "/sequel/mta"
    And I add request header "Authorization" as "Bearer <--Oauth.txt/Token"
    And I add request header "Content-Type" as "<--config.props/CONTENT-TYPE"
    And I add request header "Ocp-Apim-Subscription-Key" as "<--config.props/OCP-APIM-SUBSCRIPTION-KEY"
    When I use json template "data/payload/DualToSequl/hcMTABasic.json"
    And I mention "$..policyRef" as "<--ID.txt/PolicyRefID"
    And I mention "$..effectiveDate" as "<--TimeStamp.txt/effectiveDate"
    And I mention "$..policyDsc" as "Modified_A_HC_MTA_PRM_$$timeStamp"

    And I print request
    And I wait for "2" seconds

    #    Below Code will invoke Post API call and update MTA for  Declaration
    Then I invoke the POST API with json payload
    And I print response
    And I save response to "Response.txt/MTAResponse"
    And I save value "$..messageId-->message.txt/MTA_MessageID"
    And I print from file "<--Response.txt/MTAResponse"
    And I wait for "2" seconds

    #    Below code will fetch Request ID and Assert Status Code and Created.
    Given I set endpoint as "<--config.props/BASE_URI_DUAL_TO_SEQUL" with API "/sequel/status/" along with "<--message.txt/MTA_MessageID"
    And I add request header "Authorization" as "Bearer <--Oauth.txt/Token"
    And I add request header "Content-Type" as "<--config.props/CONTENT-TYPE"
    And I add request header "Ocp-Apim-Subscription-Key" as "<--config.props/OCP-APIM-SUBSCRIPTION-KEY"
    And I print request
    Then I invoke the GET API
    And I print response

#    Below Code is used to recursive to confirm status is changed from Accepted to Created
    Given I set endpoint as "<--config.props/BASE_URI_DUAL_TO_SEQUL" with API "/sequel/status/" along with "<--message.txt/MTA_MessageID"
    And I add request header "Authorization" as "Bearer <--Oauth.txt/Token"
    And I add request header "Content-Type" as "<--config.props/CONTENT-TYPE"
    And I add request header "Ocp-Apim-Subscription-Key" as "<--config.props/OCP-APIM-SUBSCRIPTION-KEY"
    And Verify status is changed to Accepted from Created
    And I save response to "CreatedResponse.txt/MTACreatedResponse"
    And I verify "$..status" contains text "Created"
    And I verify "$..statusCode" contains text "201"
    And I print response

  @smoke  @MTA  @NOtDOne
  Scenario: Create Declaration and Do MTA multiple Times
    #    Test Case id in Azure Devops 10070

    #    Create Declaration in Dual Services
    Given I set endpoint as "<--config.props/BASE_URI_DUAL_TO_SEQUL" with API "/sequel/declaration"
    And I set Oauth Header with "<--config.props/DualToSequel_ID" and "<--config.props/DualToSequel_Secret" and "<--config.props/DualToSequel_Scope" and "<--config.props/DualToSequel_grant_type" and "<--config.props/DualToSequel_URL"
    And I print response
    And I save value "$..access_token-->Oauth.txt/Token"
    And I add request header "Authorization" as "Bearer <--Oauth.txt/Token"
    And I add request header "Content-Type" as "<--config.props/CONTENT-TYPE"
    And I add request header "Ocp-Apim-Subscription-Key" as "<--config.props/OCP-APIM-SUBSCRIPTION-KEY"
    When I use json template "data/payload/DualToSequl/Declaration.json"
    And I mention "$..policyDsc" as "A_HC_MTA_$$timeStamp"
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

    #    Create MTA for above Declaration .
    Given I set endpoint as "<--config.props/BASE_URI_DUAL_TO_SEQUL" with API "/sequel/mta"
    And I add request header "Authorization" as "Bearer <--Oauth.txt/Token"
    And I add request header "Content-Type" as "<--config.props/CONTENT-TYPE"
    And I add request header "Ocp-Apim-Subscription-Key" as "<--config.props/OCP-APIM-SUBSCRIPTION-KEY"
    When I use json template "data/payload/DualToSequl/hcMTABasic.json"
    And I mention "$..policyRef" as "<--ID.txt/PolicyRefID"
    And I mention "$..effectiveDate" as "<--TimeStamp.txt/effectiveDate"
    And I mention "$..policyDsc" as "Modified_A_HC_MTA_$$timeStamp"

    And I print request
    And I wait for "2" seconds

    #    Below Code will invoke Post API call and update MTA for  Declaration
    Then I invoke the POST API with json payload
    And I print response
    And I save response to "Response.txt/MTAResponse"
    And I save value "$..messageId-->message.txt/MTA_MessageID"
    And I print from file "<--Response.txt/MTAResponse"
    And I wait for "2" seconds

    #    Create MTA for above Declaration Second Time .
    Given I set endpoint as "<--config.props/BASE_URI_DUAL_TO_SEQUL" with API "/sequel/mta"
    And I add request header "Authorization" as "Bearer <--Oauth.txt/Token"
    And I add request header "Content-Type" as "<--config.props/CONTENT-TYPE"
    And I add request header "Ocp-Apim-Subscription-Key" as "<--config.props/OCP-APIM-SUBSCRIPTION-KEY"
    When I use json template "data/payload/DualToSequl/hcMTABasic.json"
    And I mention "$..policyRef" as "<--ID.txt/PolicyRefID"
    And I mention "$..effectiveDate" as "<--TimeStamp.txt/effectiveDate"
    And I mention "$..policyDsc" as "2_Modified_A_HC_MTA_$$timeStamp"

    And I print request
    And I wait for "2" seconds

    #    Below Code will invoke Post API call and update MTA for  Declaration Second Time
    Then I invoke the POST API with json payload
    And I print response
    And I save response to "Response.txt/MTAResponse"
    And I save value "$..messageId-->message.txt/MTA_MessageID"
    And I print from file "<--Response.txt/MTAResponse"
    And I wait for "2" seconds

    #    Create MTA for above Declaration Third Time.
    Given I set endpoint as "<--config.props/BASE_URI_DUAL_TO_SEQUL" with API "/sequel/mta"
    And I add request header "Authorization" as "Bearer <--Oauth.txt/Token"
    And I add request header "Content-Type" as "<--config.props/CONTENT-TYPE"
    And I add request header "Ocp-Apim-Subscription-Key" as "<--config.props/OCP-APIM-SUBSCRIPTION-KEY"
    When I use json template "data/payload/DualToSequl/hcMTABasic.json"
    And I mention "$..policyRef" as "<--ID.txt/PolicyRefID"
    And I mention "$..effectiveDate" as "<--TimeStamp.txt/effectiveDate"
    And I mention "$..policyDsc" as "3_Modified_A_HC_MTA_$$timeStamp"

    And I print request
    And I wait for "2" seconds

    #    Below Code will invoke Post API call and update MTA for  Declaration Third Time
    Then I invoke the POST API with json payload
    And I print response
    And I save response to "Response.txt/MTAResponse"
    And I save value "$..messageId-->message.txt/MTA_MessageID"
    And I print from file "<--Response.txt/MTAResponse"
    And I wait for "2" seconds

    #    Below code will fetch Request ID and Assert Status Code and Created.
    Given I set endpoint as "<--config.props/BASE_URI_DUAL_TO_SEQUL" with API "/sequel/status/" along with "<--message.txt/MTA_MessageID"
    And I add request header "Authorization" as "Bearer <--Oauth.txt/Token"
    And I add request header "Content-Type" as "<--config.props/CONTENT-TYPE"
    And I add request header "Ocp-Apim-Subscription-Key" as "<--config.props/OCP-APIM-SUBSCRIPTION-KEY"
    And I print request
    Then I invoke the GET API
    And I print response

#    Below Code is used to recursive to confirm status is changed from Accepted to Created
    Given I set endpoint as "<--config.props/BASE_URI_DUAL_TO_SEQUL" with API "/sequel/status/" along with "<--message.txt/MTA_MessageID"
    And I add request header "Authorization" as "Bearer <--Oauth.txt/Token"
    And I add request header "Content-Type" as "<--config.props/CONTENT-TYPE"
    And I add request header "Ocp-Apim-Subscription-Key" as "<--config.props/OCP-APIM-SUBSCRIPTION-KEY"
    And Verify status is changed to Accepted from Created
    And I save response to "CreatedResponse.txt/MTACreatedResponse"
    And I verify "$..status" contains text "Created"
    And I verify "$..statusCode" contains text "201"
    And I print response



  @smoke  @MTA  @Phase2
  Scenario: Create Declaration and DO MTA without any changes and check the behavior
    #    Test Case id in Azure Devops 10071

    #    Create Declaration in Dual Services
    Given I set endpoint as "<--config.props/BASE_URI_DUAL_TO_SEQUL" with API "/sequel/declaration"
    And I set Oauth Header with "<--config.props/DualToSequel_ID" and "<--config.props/DualToSequel_Secret" and "<--config.props/DualToSequel_Scope" and "<--config.props/DualToSequel_grant_type" and "<--config.props/DualToSequel_URL"
    And I print response
    And I save value "$..access_token-->Oauth.txt/Token"
    And I add request header "Authorization" as "Bearer <--Oauth.txt/Token"
    And I add request header "Content-Type" as "<--config.props/CONTENT-TYPE"
    And I add request header "Ocp-Apim-Subscription-Key" as "<--config.props/OCP-APIM-SUBSCRIPTION-KEY"
    When I use json template "data/payload/DualToSequl/Declaration.json"
    And I mention "$..policyDsc" as "A_HC_NO_MTA_$$timeStamp"
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

    #    Create MTA without any changes for above Declaration .
    Given I set endpoint as "<--config.props/BASE_URI_DUAL_TO_SEQUL" with API "/sequel/mta"
    And I add request header "Authorization" as "Bearer <--Oauth.txt/Token"
    And I add request header "Content-Type" as "<--config.props/CONTENT-TYPE"
    And I add request header "Ocp-Apim-Subscription-Key" as "<--config.props/OCP-APIM-SUBSCRIPTION-KEY"
    When I use json template "data/payload/DualToSequl/hcMTABasic.json"
    And I mention "$..policyRef" as "<--ID.txt/PolicyRefID"
    And I Remove "$..effectiveDate" from Json
    And I Remove "$..policyDetails" from Json

    And I print request
    And I wait for "2" seconds

    #    Below Code will invoke Post API call and update MTA for  Declaration
    Then I invoke the POST API with json payload
    And I print response
    And I save response to "Response.txt/MTAResponse"
    And I save value "$..messageId-->message.txt/MTA_MessageID"
    And I print from file "<--Response.txt/MTAResponse"
    And I wait for "2" seconds

    #    Below code will fetch Request ID and Assert Status Code and Created.
    Given I set endpoint as "<--config.props/BASE_URI_DUAL_TO_SEQUL" with API "/sequel/status/" along with "<--message.txt/MTA_MessageID"
    And I add request header "Authorization" as "Bearer <--Oauth.txt/Token"
    And I add request header "Content-Type" as "<--config.props/CONTENT-TYPE"
    And I add request header "Ocp-Apim-Subscription-Key" as "<--config.props/OCP-APIM-SUBSCRIPTION-KEY"
    And I print request
    Then I invoke the GET API
    And I print response
    And I verify "$..status" contains text "BadRequest"
    And I verify "$..statusCode" contains text "400"
