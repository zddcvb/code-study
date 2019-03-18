package com.jollyclass.ane;

import com.adobe.fre.FREContext;
import com.adobe.fre.FREFunction;
import com.adobe.fre.FREObject;
import com.adobe.fre.FREWrongThreadException;

public class TestFunc implements FREFunction {

	@Override
	public FREObject call(FREContext arg0, FREObject[] arg1) {
		  FREObject result=null;
	        try {
	            result=FREObject.newObject("Ane测试");
	        } catch (FREWrongThreadException e) {
	            e.printStackTrace();
	        }
	        return result;
	}

}
