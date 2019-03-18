package com.jollyclass.struts.convert;

import java.util.Map;
import org.apache.struts2.util.StrutsTypeConverter;

import com.jollyclass.bean.User;

public class UserConvert extends StrutsTypeConverter {

	@Override
	public Object convertFromString(Map map, String[] values, Class clazz) {
		String[] strs = values[0].split(",");
		User user = new User();
		user.setName(strs[0]);
		user.setPassword(strs[1]);
		return user;
	}

	@Override
	public String convertToString(Map arg0, Object arg1) {
		return null;
	}

}
