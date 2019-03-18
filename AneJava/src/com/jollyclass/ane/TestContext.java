package com.jollyclass.ane;

import java.util.HashMap;
import java.util.Map;

import com.adobe.fre.FREContext;
import com.adobe.fre.FREFunction;

public class TestContext extends FREContext{

	@Override
	public void dispose() {
		
	}

	@Override
	public Map<String, FREFunction> getFunctions() {
		Map<String, FREFunction> map=new HashMap<>();
		map.put("testFunc", new TestFunc());
		return map;
	}

}
