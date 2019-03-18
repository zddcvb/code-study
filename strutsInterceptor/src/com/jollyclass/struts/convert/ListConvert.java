package com.jollyclass.struts.convert;

import java.util.ArrayList;
import java.util.Map;

import org.apache.jasper.tagplugins.jstl.core.ForEach;
import org.apache.struts2.util.StrutsTypeConverter;

import com.jollyclass.bean.User;

public class ListConvert extends StrutsTypeConverter {

	@Override
	public Object convertFromString(Map map, String[] values, Class clazz) {
		ArrayList<String> lists = new ArrayList<String>();
		for (int i = 0; i < values.length; i++) {
			System.out.println(values[i]);
			lists.add(values[i]);
		}
		return lists;
	}

	@Override
	public String convertToString(Map arg0, Object arg1) {
		return null;
	}

}
