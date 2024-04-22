package com.features.stepDefs;

import com.dual.core.HelperUtils;
import com.dual.core.JsonUtils;
import com.dual.core.Rest;
import com.jayway.jsonpath.JsonPath;
import com.jayway.jsonpath.ReadContext;
import cucumber.api.Scenario;
import cucumber.api.java.After;
import cucumber.api.java.Before;
import cucumber.api.java.en.Given;
import cucumber.api.java.en.Then;
import cucumber.api.java.en.When;
import io.restassured.http.Header;
import io.restassured.http.Headers;
import io.restassured.response.Response;
import org.apache.commons.io.IOUtils;
import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;

import java.io.FileNotFoundException;
import java.io.FileReader;
import java.io.FileWriter;
import java.io.IOException;
import java.sql.Timestamp;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.List;

import static io.restassured.RestAssured.given;
import static org.assertj.core.api.Assertions.assertThat;

public class StepDefCore {
	
	public static ReadContext resJsonContext;
	public static String stringTemplPayLoad;
	public static String stringReqPayLoad;
	public static Response response;
	public static String url;
	public static Headers jsonContentHeader;
	private Scenario scenario;
	private static int count = 0;
	private static final Logger logger = LogManager.getLogger(StepDefCore.class);
	
	@Before
    public void before(Scenario scenario) {
        this.scenario = scenario;
		logger.info("Scenario - "+scenario.getName());
    }
	  
	@Given("^I set endpoint as \"([^\"]*)\" with API \"([^\"]*)\"$")
	public static void setEndpoint(String baseURL, String api) {
		baseURL = HelperUtils.analyzeValue(baseURL);
		api = HelperUtils.analyzeValue(api);
		url = baseURL + api;
	}

	@Given("^I set endpoint as \"([^\"]*)\" with API \"([^\"]*)\" along with \"([^\"]*)\"$")
	public void setEndpointAppID(String baseURL, String api, String path2) throws Exception, IOException {		
		baseURL = HelperUtils.analyzeValue(baseURL);
		api = HelperUtils.analyzeValue(api);
		path2 = HelperUtils.analyzeValue(path2);
		url = baseURL + api + path2;
	}
	
	@Given("^I set endpoint as \"([^\"]*)\" with API \"([^\"]*)\" along with \"([^\"]*)\" and \"([^\"]*)\"$")
	public void setEndpointAppID(String baseURL, String api, String path2, String path3) throws Exception, IOException {		
		baseURL = HelperUtils.analyzeValue(baseURL);
		api = HelperUtils.analyzeValue(api);
		path2 = HelperUtils.analyzeValue(path2);
		path3 = HelperUtils.analyzeValue(path3);
		url = baseURL + api + path2 + path3;
		logger.info("URL is --> " + url);
	}
	
	@Given("^I use json template \"([^\"]*)\"$")
	public static void loadTemplateJSON(String jsonFileName) throws FileNotFoundException, IOException {
		StepDefCore.stringTemplPayLoad = IOUtils.toString(new FileReader("src/test/resources/" + jsonFileName));
		StepDefCore.stringReqPayLoad = StepDefCore.stringTemplPayLoad;
	}
	
	@When("^I invoke the GET API$")
    public void invokeAPI()  {
		logger.info(jsonContentHeader);
        response = Rest.getResource(url,jsonContentHeader);
        resJsonContext = JsonPath.parse(response.getBody().asString());   
//        assertThat(response.getStatusCode()).isEqualTo(200);
        jsonContentHeader=null;
        listHeaders.clear();
    }
	
	@When("^I invoke the POST API with json payload$")
	public static void invokePostAPIWithPayload()  {
		logger.info(url);
		logger.info(stringReqPayLoad);
		logger.info(jsonContentHeader);

		response = Rest.postResource(url, stringReqPayLoad, jsonContentHeader);
		resJsonContext = JsonPath.parse(response.getBody().asString());
		jsonContentHeader=null;
        listHeaders.clear();

	}
	
	@When("^I invoke the PUT API with json payload$")
	public void invokePutAPIWithPayload()  {
		response = Rest.putResource(url, stringReqPayLoad, jsonContentHeader);
		resJsonContext = JsonPath.parse(response.getBody().asString());	
		assertThat(200).isEqualTo(response.getStatusCode());
		jsonContentHeader=null;
        listHeaders.clear();
	}
	
	@Then("^I invoke the PUT API with json payload and expect HTTP Code \"([^\"]*)\"$")
	public void invokePutAPIAndVerifyStatusCode(int expectedStatusCode) 
	{
	response = Rest.putResource(url, stringReqPayLoad, jsonContentHeader);
	resJsonContext = JsonPath.parse(response.getBody().asString());
	assertThat(expectedStatusCode).isEqualTo(response.getStatusCode());
	jsonContentHeader=null;
	listHeaders.clear();
	}
	
	@Then("^I verify the status code to be \"([^\"]*)\"$")
	public void verifyStatusCode(int expectedStatusCode) {
		int resStatusCode = response.getStatusCode();
		scenario.write("Status Code: "  + resStatusCode);
		assertThat(expectedStatusCode).isEqualTo(resStatusCode);
	}

	@Then("^Verify status is changed to Accepted from Created$")
	public void verify_status_is_changed_to_Created_from_Accepted() throws Throwable {
		// Write code here that turns the phrase above into concrete actions

//		logger.info(url);
//		logger.info(jsonContentHeader);
		response = Rest.getResource(url,jsonContentHeader);

//		response = Rest.postResource(url, stringReqPayLoad, jsonContentHeader);
		resJsonContext = JsonPath.parse(response.getBody().asString());
//		logger.info(resJsonContext);
//		StepDefJson.readValueFromResponseForSubString("$..status","Created");
		String expectedValue = "Created";
		String attributeValue = HelperUtils.returnValueFromResponse(resJsonContext, "$..status");
		logger.info(attributeValue);
		expectedValue = HelperUtils.analyzeValue(expectedValue);
//		assertThat(attributeValue).containsIgnoringCase(expectedValue);
		if (attributeValue.equals("Accepted") && count < 9)
		{
			count++;
			logger.info("---"+count+"----");
			Thread.sleep(5000);
			verify_status_is_changed_to_Created_from_Accepted();
		}
		count = 0;
		jsonContentHeader=null;
		listHeaders.clear();
	}

	@Then("^Fetch Policy Ref from PolicyId Received from status Outcome$")
	public void fetch_Policy_Ref_from_PolicyId_Received_from_status_Outcome() throws Throwable {
		// Write code here that turns the phrase above into concrete actions


//		resJsonContext = JsonPath.parse("{\n" +
//				"    \"error\": null,\n" +
//				"    \"completed\": \"2021-04-05T08:38:43+00:00\",\n" +
//				"    \"resources\": [\n" +
//				"        \"/api/declarations?PolicyLinkId=989824940\"\n" +
//				"    ],\n" +
//				"    \"resourceIds\": null,\n" +
//				"    \"requestId\": \"03d41769-8fe3-4379-b808-cac60df5e729\",\n" +
//				"    \"statusCode\": 201,\n" +
//				"    \"status\": \"Created\",\n" +
//				"    \"created\": \"2021-04-05T08:38:35+00:00\",\n" +
//				"    \"message\": null\n" +
//				"}");


		String objResult = JsonUtils.readValueFromJSON(StepDefCore.resJsonContext, "$..resources");
		logger.info(objResult);
		String[] arrOfStr =objResult.split("=");
		String Policy_Id = arrOfStr[1].substring(0, arrOfStr[1].length() - 2);
		logger.info(Policy_Id);

		response =
				given().auth().preemptive(). basic("dual.gateway.sequel","MGEyNWQzN2ItZGQ0ZC00YTQwLWE0ZGItODIzNWI5MzJkZmZj")
//						.headers(headers)
						.params("grant_type", "client_credentials")
						.params("scope", "gateway.declarations.get gateway.declarations.post").when()
						.post("https://uat.dual.sequel.com/Authentication/connect/token");
		logger.info(response.asString());
		logger.info(response.path("access_token").toString());
		addRequestHeaders("Authorization", "Bearer "+response.path("access_token").toString());
		addRequestHeaders("accept", "application/json");
		addRequestHeaders("x-sequelauth", "AWSVERISKP\\SAK_uat");

		response = Rest.getResource("https://apigwyuat.dual.sequel.com/api/declarations/v1?policylinkid="+Policy_Id,jsonContentHeader);

//		response = Rest.postResource(url, stringReqPayLoad, jsonContentHeader);
		logger.info(response.asString());
		resJsonContext = JsonPath.parse(response.getBody().asString());

		logger.info(resJsonContext);
//		StepDefJson.saveElement("");
		jsonContentHeader=null;
		listHeaders.clear();

	}

	public static List<Header> listHeaders = new ArrayList<Header>();
	@Then("^I add request header \"([^\"]*)\" as \"([^\"]*)\"$")
	public static void addRequestHeaders(String key, String value) {
		String value1 = HelperUtils.analyzeValue(value);
		listHeaders.add(new Header(key,value1));
		jsonContentHeader = new Headers(listHeaders);
		logger.info(jsonContentHeader);
	}


	@Given("^I set Oauth Header with \"([^\"]*)\" and \"([^\"]*)\" and \"([^\"]*)\" and \"([^\"]*)\" and \"([^\"]*)\"$")
	public void i_set_Oauth_Header_with(String id,String secret,String scope,String grant,String url) throws Throwable {
		// Write code here that turns the phrase above into concrete actions
		String client_id = HelperUtils.analyzeValue(id);
		String client_secret = HelperUtils.analyzeValue(secret);
		String client_scope = HelperUtils.analyzeValue(scope);
		String client_grant_type = HelperUtils.analyzeValue(grant);
		String client_url = HelperUtils.analyzeValue(url);

		logger.info(("client_id"+client_id));
		logger.info("client_secret"+client_secret);
		logger.info("client_scope"+client_scope);
		logger.info("client_grant_type"+client_grant_type);
		logger.info("client_url"+client_url);


		logger.info("oauthAuth");
//		RestAssured.baseURI = "https://login.microsoftonline.com/425682c2-59d3-44d4-a709-0a3c26593cb7";
//        PreemptiveOAuth2HeaderScheme auth2Scheme=new PreemptiveOAuth2HeaderScheme();
//		Headers headers = new Headers(new Header("Content-Type", "application/x-www-form-urlencoded"),new Header("Host", "login.microsoftonline.com"));
		addRequestHeaders("Content-Type", "application/x-www-form-urlencoded");
		addRequestHeaders("Host", "login.microsoftonline.com");

		response =
				given().auth().preemptive(). basic(client_id,client_secret)
//						.headers(headers)
						.params("grant_type", client_grant_type)
						.params("scope", client_scope).when()
						.post(client_url);
		logger.info("Response :"+response.statusCode());
		logger.info("Response :"+response.asString());
		resJsonContext = JsonPath.parse(response.getBody().asString());

//		listHeaders.add(new Header("Key",value1));
//		jsonContentHeader = new Headers(listHeaders);
//		logger.info(jsonContentHeader);
        jsonContentHeader=null;
        listHeaders.clear();

//		throw new PendingException();
	}



	
	@Then("^I print request$")
    public void printFullRequest() {

		scenario.write("REQUEST: " + stringReqPayLoad);
		logger.info("REQUEST :"+stringReqPayLoad);

    }
	
	@Then("^I print response$")
	public void printFullResponse() {
		scenario.write("RESPONSE: " + response.getBody().asString());
		logger.info("RESPONSE :"+response.getBody().asString());
	}
	
	@Then("^I print from file \"([^\"]*)\"$")
	public void printFullResponse(String propValue) {
		propValue = HelperUtils.analyzeValue(propValue);
		scenario.write("FileValue: " + propValue);
	}
   
    @Then("^I verify request and response$")
    public void verifyRequest() {
        assertThat(stringReqPayLoad).isEqualTo(response.getBody().asString());
        logger.info("This is " + stringReqPayLoad.equalsIgnoreCase(response.getBody().asString()));
    }
    
    @Then("^I invoke the DELETE API$")
    public void invokeDelete(){
            response = Rest.deleteResource(url, jsonContentHeader);
            resJsonContext = JsonPath.parse(response.getBody().asString());   
            assertThat(200).isEqualTo(response.getStatusCode());
    }
    

  //Save request to json file
  	@Then("^I save request to \"([^\"]*)\"$")
      public void storeFullResponse(String filename) {
  		try{
  			FileWriter file = new FileWriter("src/test/resources/data/payload/"+filename);
  			file.write(stringReqPayLoad.toString());
  			file.close();
  		}catch (Exception e) {
  			logger.info(e.getMessage());
  		}
      }


	@Then("^I save response to \"([^\"]*)\"$")
    public void saveFullResponse(String filekey) {
        //HelperUtils.analyzeValue(response.getBody().asString() + fileKey);
		String filename = filekey.split("/")[0];
		String key = filekey.split("/")[1];
        HelperUtils.saveData(filename, key, response.getBody().asString());

    }
	

	@After
	public void afterScenario(){
		logger.info("End of Scenario");
		jsonContentHeader=null;
        listHeaders.clear();
		
	}
	@Then("^I wait for \"([^\"]*)\" seconds$")
    public void waitForSeconds(int waitTime) throws Exception {
		Thread.sleep(waitTime*1000);
    }

	@Given("^I set endpoint as \"([^\"]*)\" with API \"([^\"]*)\" along with \"([^\"]*)\" and \"([^\"]*)\" and \"([^\"]*)\"$")
	public void setEndpointCategory(String baseURL, String api, String path2, String path3,String path4) throws Exception, IOException {		
		baseURL = HelperUtils.analyzeValue(baseURL);
		api = HelperUtils.analyzeValue(api);
		path2 = HelperUtils.analyzeValue(path2);
		path3 = HelperUtils.analyzeValue(path3);
		path4 = HelperUtils.analyzeValue(path4);
		url = baseURL + api + path2 + path3 + path4 ;
		logger.info("URL is --> " + url);
	}

	@Given("^Get Current TimeStamp$")
	public void getCurrentTimestamp()
	{
		SimpleDateFormat sdf = new SimpleDateFormat("yyyy.MM.dd.HH.mm.ss");
		Timestamp timestamp = new Timestamp(System.currentTimeMillis());
		logger.info(timestamp);
	}
}

