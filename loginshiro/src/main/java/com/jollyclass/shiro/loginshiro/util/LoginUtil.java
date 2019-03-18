package com.jollyclass.shiro.loginshiro.util;

import java.util.Set;

import org.apache.shiro.SecurityUtils;
import org.apache.shiro.authc.AuthenticationToken;
import org.apache.shiro.authc.UsernamePasswordToken;
import org.apache.shiro.config.Ini;
import org.apache.shiro.config.IniSecurityManagerFactory;
import org.apache.shiro.mgt.SecurityManager;
import org.apache.shiro.subject.PrincipalCollection;
import org.apache.shiro.subject.Subject;
import org.apache.shiro.util.Factory;

import junit.framework.Assert;

public class LoginUtil {
	public void loginBasic(String configuration) {
		Factory<SecurityManager> factory = new IniSecurityManagerFactory(configuration);
		SecurityManager manager = factory.getInstance();
		SecurityUtils.setSecurityManager(manager);
		Subject subject = SecurityUtils.getSubject();
		AuthenticationToken token = new UsernamePasswordToken("mary", "123456");
		try {
			subject.login(token);
		} catch (Exception e) {
			e.printStackTrace();
		}
		PrincipalCollection principals = SecurityUtils.getSubject().getPrincipals();
		System.out.println(principals.asList());
		// Assert.assertEquals(2, principals.asList().size());
		subject.logout();
		
	}
	public void loginRealm() {
		Factory<SecurityManager> factory = new IniSecurityManagerFactory("classpath:userInfo-realm.ini");
		SecurityManager manager = factory.getInstance();
		SecurityUtils.setSecurityManager(manager);
		Subject subject = SecurityUtils.getSubject();
		AuthenticationToken token = new UsernamePasswordToken("mary", "123456");
		try {
			subject.login(token);
		} catch (Exception e) {
			e.printStackTrace();
		}
		 Assert.assertEquals(true, subject.isAuthenticated());
		subject.logout();
	}
	public void loginJDBCRealm() {
		Factory<SecurityManager> factory = new IniSecurityManagerFactory("classpath:jdbc-userInfo-realm.ini");
		SecurityManager manager = factory.getInstance();
		SecurityUtils.setSecurityManager(manager);
		Subject subject = SecurityUtils.getSubject();
		AuthenticationToken token = new UsernamePasswordToken("zhang", "123");
		try {
			subject.login(token);
		} catch (Exception e) {
			e.printStackTrace();
		}
		 Assert.assertEquals(true, subject.isAuthenticated());
		subject.logout();
	}
}
