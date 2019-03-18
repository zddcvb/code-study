package com.jollyclass.shiro.loginshiro.realm;

import org.apache.shiro.authc.AuthenticationException;
import org.apache.shiro.authc.AuthenticationInfo;
import org.apache.shiro.authc.AuthenticationToken;
import org.apache.shiro.authc.IncorrectCredentialsException;
import org.apache.shiro.authc.SimpleAuthenticationInfo;
import org.apache.shiro.authc.UnknownAccountException;
import org.apache.shiro.authc.UsernamePasswordToken;
import org.apache.shiro.realm.Realm;

public class MyRealm1 implements Realm {

	public String getName() {
		System.out.println("getName");
		return "myRealm";
	}

	public boolean supports(AuthenticationToken token) {
		System.out.println("supports");
		return token instanceof UsernamePasswordToken;
	}

	public AuthenticationInfo getAuthenticationInfo(AuthenticationToken token) throws AuthenticationException {
		System.out.println("getAuthenticationInfo");
		String userName = (String) token.getPrincipal();
		String password = new String((char[]) token.getCredentials());
		System.out.println("userName:" + userName + ":password:" + password);
		if (!"zhang".equals(userName)) {
			throw new UnknownAccountException(); // 如果用户名错误
		}
		if (!"123".equals(password)) {
			throw new IncorrectCredentialsException(); // 如果密码错误
		}
		return new SimpleAuthenticationInfo(userName, password, getName());
	}

}
