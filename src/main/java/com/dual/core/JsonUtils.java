package com.dual.core;

import java.util.List;
import com.jayway.jsonpath.ReadContext;

public class JsonUtils {
	public static String readValueFromJSON(ReadContext resJsonContext, String jsonQuery) {		
		List<String> output = resJsonContext.read(jsonQuery);
		if(output.size() > 1) {
			return String.valueOf(output.toString());
		} else if (output.size() == 1){
			return String.valueOf(output.get(0));
		}else{
			return null;
		}
	}
	
}
