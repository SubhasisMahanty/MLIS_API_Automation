package com.dual.core;

import io.restassured.RestAssured;
import io.restassured.http.Headers;
import io.restassured.response.Response;
import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;

import static io.restassured.RestAssured.given;

public class Rest {

	private static final String JSON_TYPE = "application/json";
	private static final Logger LOGGER = LogManager.getLogger(Rest.class);
	
	public static final Response getResource(final String url, Headers jsonContentHeader) {
		if (jsonContentHeader != null) {
			return given().headers(jsonContentHeader).contentType(Rest.JSON_TYPE).when().get(url);
		} else
			return given().contentType(Rest.JSON_TYPE).when().get(url);
	}

	public static final Response postResource(final String url, final String jsonPayload, Headers jsonContentHeader) {
		LOGGER.info("Invoke the Rest endpoint[{}] with request payload[{}].", url, jsonPayload);
		RestAssured.useRelaxedHTTPSValidation();
		if (jsonContentHeader != null) {
			return given().headers(jsonContentHeader).contentType(Rest.JSON_TYPE).body(jsonPayload).when().post(url);

		} else
			return given().contentType(Rest.JSON_TYPE).body(jsonPayload).when().post(url);
	}

	public static final Response putResource(final String url, final String jsonPayload, Headers jsonContentHeader) {
		LOGGER.info("Invoke the Rest endpoint[{}] with request payload[{}].", url, jsonPayload);
		if (jsonContentHeader != null) {
			return given().headers(jsonContentHeader).contentType(Rest.JSON_TYPE).body(jsonPayload).when().put(url);
		} else
			return given().contentType(Rest.JSON_TYPE).body(jsonPayload).when().put(url);
	}




	public static final Response deleteResource(final String url, Headers jsonContentHeader) {
		if (jsonContentHeader != null) {
			return given().headers(jsonContentHeader).contentType(Rest.JSON_TYPE).when().delete(url);
		} else
			return given().contentType(Rest.JSON_TYPE).when().delete(url);
	}

}
