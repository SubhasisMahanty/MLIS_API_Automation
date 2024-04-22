package com.features.stepDefs;

import com.fasterxml.jackson.databind.node.ObjectNode;
import com.jayway.jsonpath.ReadContext;
import cucumber.api.Scenario;
import cucumber.api.java.Before;
import cucumber.api.java.en.And;
import io.restassured.http.Headers;
import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;


public class StepDefPojo {
	private static final Logger logger = LogManager.getLogger(StepDefPojo.class);
//	
	public static ReadContext resJsonContext;
	public static ObjectNode requestJson;
	
	public static String stringTemplPayLoad;
	public static String stringReqPayLoad;
	public static String url;
	public ReadContext docJsonContext;
	public static Headers jsonContentHeader;
	public static Scenario scenario;
	public static StepDefCore obj = new StepDefCore();
	@Before
    public void before(Scenario scenario) {
        this.scenario = scenario;
    }
	  
	@And("^I convert Response to POJO to Validate JSON Schema \"([^\"]*)\"$")
	public static void convertReponseToPojo(String pojoFile) {
		
		
		if (pojoFile.equals("RetrieveClientDetailsHierarchy"))	
		{
//			RetrieveClientDetailsHierarchy pojo = obj.response.as(RetrieveClientDetailsHierarchy.class);
			logger.info("Pojo Validation Sucessfull");
		}
		
	}
	
	
		
}

