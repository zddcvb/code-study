package com.jollyclass.shiro.loginshiro;

import com.jollyclass.shiro.loginshiro.util.LoginUtil;

/**
 * Hello world!
 *
 */
public class LoginShiro {
	public static void main(String[] args) {
		LoginUtil util = new LoginUtil();
		// util.loginBasic();
		//String configuration = "classpath:realm-successAll.ini";
		//String configuration="classpath:realm-first.ini";
		String configuration="classpath:realm-atLeast.ini";
		util.loginBasic(configuration);
	}
}
