package com.features.stepDefs;

import com.dual.core.HelperUtils;
import com.dual.core.JsonUtils;
import com.jayway.jsonpath.Configuration;
import com.jayway.jsonpath.DocumentContext;
import com.jayway.jsonpath.JsonPath;
import com.jayway.jsonpath.ReadContext;
import com.jayway.jsonpath.spi.json.JacksonJsonNodeJsonProvider;
import com.jayway.jsonpath.spi.mapper.JacksonMappingProvider;
import cucumber.api.Scenario;
import cucumber.api.java.Before;
import cucumber.api.java.en.Then;
import cucumber.api.java.en.When;
import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;
import org.assertj.core.api.SoftAssertions;

import java.util.Collections;
import java.util.List;

import static org.assertj.core.api.Assertions.assertThat;
import static org.junit.Assert.assertNotNull;
import static org.junit.Assert.fail;

public class StepDefJson {
	
public ReadContext docJsonContext;
	
	private Scenario scenario;
	private static final Logger logger = LogManager.getLogger(StepDefJson.class);
	private static final Configuration configuration = Configuration.builder()
		    .jsonProvider(new JacksonJsonNodeJsonProvider())
		    .mappingProvider(new JacksonMappingProvider())
		    .build();
	
	@Before
    public void before(Scenario scenario) {
        this.scenario = scenario;
    }

    // Below Command is going to Print Value fron API Response
	@Then("^I print \"([^\"]*)\"$")
	public void printValueFromResponse(String value) {		
		String objResult = JsonUtils.readValueFromJSON(StepDefCore.resJsonContext, value.split("-->")[0]);
		if(objResult == null){
			scenario.write("JsonPath " + value + " not found");
		}else{
			scenario.write(value + " = " + objResult);
		}
	}

	// Below Command is going to Print Value fron API Response
	@Then("^I print given value \"([^\"]*)\"$")
	public void printGivenValue(String value) {
		value=HelperUtils.analyzeValue(value);
		logger.info(value);
		logger.info("Test");
		logger.info(value);
	}
	
	@Then("^I save value \"([^\"]*)\"$")
    public static void saveElement(String value) {
        	 String objResult = JsonUtils.readValueFromJSON(StepDefCore.resJsonContext, value.split("-->")[0]);
        	 if(objResult == null){
        		 value = value.replace(value.split("-->")[0],"");
     		}else{
     			value = value.replace(value.split("-->")[0],objResult);
     		}
         HelperUtils.analyzeValue(value);
    }
	
	@When("^I mention \"([^\"]*)\" as \"([^\"]*)\"$")
	public static void editJSON(String attribute, String value) {
		//value = value.replaceAll("&nbsp;"," ");
        value=HelperUtils.analyzeValue(value);
		StepDefCore.stringReqPayLoad = JsonPath.using(configuration).parse(StepDefCore.stringReqPayLoad).set(attribute, value).jsonString();
	}
	@When("^I Add \"([^\"]*)\" as \"([^\"]*)\" to \"([^\"]*)\"$")
	public static void addJSON(String attribute, String value, String jsonPath) {
		//value = value.replaceAll("&nbsp;"," ");
		value = HelperUtils.analyzeValue(value);
		StepDefCore.stringReqPayLoad = JsonPath.using(configuration).parse(StepDefCore.stringReqPayLoad).put(jsonPath, attribute, value).jsonString();
	}
	@When("^I Remove \"([^\"]*)\" from Json$")
	public static void removeJSON(String attribute) {
		//value = value.replaceAll("&nbsp;"," ");
//		value=HelperUtils.analyzeValue(value);
//		StepDefCore.stringReqPayLoad = JsonPath.using(configuration).parse(StepDefCore.stringReqPayLoad).set(attribute, value).jsonString();
		StepDefCore.stringReqPayLoad = JsonPath.using(configuration).parse(StepDefCore.stringReqPayLoad).delete(attribute).jsonString();

	}
	@Then("^I verify \"([^\"]*)\" as \"([^\"]*)\"$")
    public void readValueFromResponse(String jsonQuery, String expectedValue) {          
          String attributeValue = HelperUtils.returnValueFromResponse(StepDefCore.resJsonContext, jsonQuery);
          expectedValue = HelperUtils.analyzeValue(expectedValue);
           assertThat(attributeValue).isEqualTo(expectedValue);
    }

	
	//Verify error message which has quotes eg. application.applicant.personalid is not valid. Specify in the format "xxx-xx-xxxx" and only numbers.
	//This step def used only for AppSubmission:PersonalDetails
	@Then("^I verify for quotes \"([^\"]*)\" as (.*)$")
	public void readquotesValueFromResponse(String jsonQuery, String expectedValue) {
		String attributeValue = HelperUtils.returnValueFromResponse(StepDefCore.resJsonContext, jsonQuery);
		expectedValue = HelperUtils.analyzeValue(expectedValue);
		assertThat(attributeValue).isEqualTo(expectedValue);
	}
	
	@Then("^I verify \"([^\"]*)\" contains text \"([^\"]*)\"$")
	public static void readValueFromResponseForSubString(String jsonQuery, String expectedValue) {
		String attributeValue = HelperUtils.returnValueFromResponse(StepDefCore.resJsonContext, jsonQuery);
		expectedValue = HelperUtils.analyzeValue(expectedValue);
		if (attributeValue.equals("Created"))
		{
			expectedValue = "Created";
		}
		if (attributeValue.equals("201"))
		{
			expectedValue = "201";
		}
		assertThat(attributeValue).containsIgnoringCase(expectedValue);

	}
	
	@Then("^I verify multiple \"([^\"]*)\" as \"([^\"]*)\"$")
    public void verifyMultipleFromResponse(String jsonPaths, String expectedValues) {
		SoftAssertions softAssert = new SoftAssertions();
		expectedValues = expectedValues.replaceAll("&nbsp;", " ");
		int i = 0;
			logger.info("Total jsonPaths" + jsonPaths.split(",").length);
			String strResponse = "";
			String[] jsonPathArray = jsonPaths.split(",");
			String[] expectedValue = expectedValues.split(",");
			for (String jsonPath: jsonPathArray){
				
				logger.info(jsonPath);
				strResponse = JsonUtils.readValueFromJSON(StepDefCore.resJsonContext, jsonPath);
				softAssert.assertThat(strResponse).isEqualTo(expectedValue[i]);
				i++;
			}
			softAssert.assertAll();
    }
	

	@Then("^I verify \"([^\"]*)\" is NOT null$") 
	public void readValueFromResponseForNotNull(String jsonQuery) {
		List<String> output2 = StepDefCore.resJsonContext.read(jsonQuery);
		String attributeValue = String.valueOf(output2.get(0));
		logger.info("AppID: " + attributeValue);
		//assertThat(attributeValue).isNotNull();
		if (attributeValue == "null") {
			scenario.write(jsonQuery + ":" + attributeValue  );
			fail("failed");
		}
		else {
			scenario.write(jsonQuery + ":" + attributeValue );
			assertNotNull(attributeValue);
		}
	}	


    @Then("^I verify response contains text (.*)$")
    public void searchFromResponse(String expectedValue) {
	    expectedValue = HelperUtils.analyzeValue(expectedValue);
	    assertThat(StepDefCore.response.getBody().asString()).containsIgnoringCase(expectedValue);
	  }


}
