package com.features.Dual;

import cucumber.api.CucumberOptions;
import cucumber.api.junit.Cucumber;
import org.junit.runner.RunWith;

@RunWith(Cucumber.class)
@CucumberOptions(
		features = "src/test/java/com/features/Dual/",
		glue = "com.features.stepDefs",
		tags = 	 {"@Phase2"},
		monochrome = true,
		plugin = { "pretty",
				"html:target/site/cucumber-pretty",
				"json:target/cucumber.json" },
		format="json:./results/cucumber.json")
public class AppTestRunner {

}
