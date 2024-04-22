package com.dual.core;

import com.jayway.jsonpath.ReadContext;
import org.apache.commons.io.IOUtils;
import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;

import java.io.*;
import java.sql.Timestamp;
import java.text.DateFormat;
import java.text.SimpleDateFormat;
import java.time.Instant;
import java.util.Date;
import java.util.List;
import java.util.Properties;
import java.util.Random;

public class HelperUtils {
	private static final Logger logger = LogManager.getLogger(HelperUtils.class);
	private static Properties prop = new Properties();
	public static String readProperty(String uri) {
		try {
			String[] array = uri.split("->", 2);
			String fileName = array[0];
			String propertyName = array[1];
			InputStream input = new FileInputStream("src/test/resources/data/" + fileName);
			prop.load(input);
			return prop.getProperty(propertyName);
		} catch (Exception e) {
			e.printStackTrace();
			return null;
		}		
	}
	

	public static String getRandomString(int length) {
		char[] chars = "abcdefghijklmnopqrstuvwxyz".toCharArray();
		StringBuilder sb = new StringBuilder(10);
		Random random = new Random();
		for (int i = 0; i < length; i++) {
		    char c = chars[random.nextInt(chars.length)];
		    sb.append(c);
		}
		String output = sb.toString();
		return output;
	}
	
	public static String analyzeValue(String arg1){
		String value=arg1.split("-->")[0];
		value = value.replaceAll("&nbsp;"," ");
//        if (value.contains("**")) {value = new StringBuffer(Math.round(new Date().getTime()/10000)).toString();}
        if (value.contains("$$rndString")) {value = getRandomString(8);}
        if(value.contains("$$epochTime"))  {value= getEpochTime(value);}
		if(value.contains("$$timeStamp"))
		{
			value= getCurrentTimestamp(value);


		}
        if(value.contains(".json"))  {try {
			value= IOUtils.toString(new FileReader("src/test/resources/" + value));
		} catch (FileNotFoundException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		} catch (IOException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}}
        //--Write and Read from Prop
        if (arg1.contains("-->")) {
        	String fileName = (arg1.split("-->")[1].split("/")[0]); 
        	String key=arg1.split("/")[1];
        	logger.info(fileName + ":" + key + "=" + value); 
        	HelperUtils.saveData(fileName, key, value); 
        }
        if (arg1.contains("<--")) {
        	String strPrefix = arg1.split("<--")[0];
        	String fileName = (arg1.split("<--")[1].split("/")[0]);
        	String key=arg1.split("/")[1];
        	value = HelperUtils.readProperty(fileName + "->" + key);
        	value = strPrefix + value;
        }
		return value;
	}

    public static void saveData(String fileName,String key,String attributeValue) {
    	try {
    		FileOutputStream fileOut = null;
	        FileInputStream fileIn = null;
	        prop.clear();
            File file = new File("src/test/resources/data/"+fileName);
            if(!file.exists()) file.createNewFile();
            fileIn = new FileInputStream(file);
            prop.load(fileIn);
            prop.setProperty(key, attributeValue);
            fileOut = new FileOutputStream(file);
            prop.store(fileOut, "Writing Content to File");
            fileOut.close();
    	}	
    	catch(Exception e) {
    		logger.info("Exception Occured"+e);
    	}
    }
    
    public static String returnValueFromResponse(ReadContext resJsonContext, String jsonQuery) {
      List<Object> output2 = resJsonContext.read(jsonQuery);
      String attributeValue = null;
      if(output2.size() > 0) {
          	attributeValue = String.valueOf(output2.get(0));
      		return attributeValue;
      } else {
    	  return null;
      }
  	}

    public static String getEpochTime(String value) {
    	return  value.substring(0,value.indexOf("$"))+Long.toString(Instant.now().toEpochMilli());
		 
	}
	public static String getCurrentTimestamp(String value)
	{
		SimpleDateFormat sdf = new SimpleDateFormat("yyyy.MM.dd.HH.mm.ss");
		String timestamp = java.lang.String.valueOf(new Timestamp(System.currentTimeMillis()));
		logger.info(timestamp);

		HelperUtils.saveData("TimeStamp.txt", "timestamp", timestamp);
		HelperUtils.saveData("TimeStamp.txt", "transactionDate", todayDate());
		HelperUtils.saveData("TimeStamp.txt", "AsAtDate", todayDate());
		HelperUtils.saveData("TimeStamp.txt", "clientSettDueDate", todayDate());
		HelperUtils.saveData("TimeStamp.txt", "UWSettDueDate", todayDate());
		HelperUtils.saveData("TimeStamp.txt", "inceptionDate", todayDate());
		HelperUtils.saveData("TimeStamp.txt", "effectiveDate", todayDate());
		HelperUtils.saveData("TimeStamp.txt", "expiryDate", expiryDate());
		HelperUtils.saveData("TimeStamp.txt", "yesterdayTransactionDate", yesterdayDate());
		return value.substring(0,value.indexOf("$"))+timestamp;
//		return  timestamp;
	}
	public static String todayDate()
	{
		DateFormat dateFormat = new SimpleDateFormat("yyyy-MM-dd");
		Date date = new Date();
		String today = dateFormat.format(date);
		return today+"T00:00:00.000000Z";

	}
	public static String yesterdayDate()
	{
		DateFormat dateFormat = new SimpleDateFormat("yyyy-MM-dd");
		Date date = new Date();
		date.setDate(date.getDate()-1);
		String yesterday = dateFormat.format(date);
//		String today = dateFormat.format(date);
		return yesterday+"T00:00:00.000000Z";

	}
	public static String expiryDate()
	{
		DateFormat dateFormat = new SimpleDateFormat("yyyy-MM-dd");
		Date date = new Date();
		date.setMonth(date.getMonth()+11);
		String expiry = dateFormat.format(date);
		return expiry+"T00:00:00.000000Z";
	}

}
