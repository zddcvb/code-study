package com.jollyclass.spring.bean;

import java.util.List;
import java.util.Map;
import java.util.Properties;
import java.util.Set;

public class UserInfo {
	private List<User> users;
	private Set<User> userSet;
	private Map<String, User> userMap;
	private Properties properties;

	public List<User> getUsers() {
		return users;
	}

	public void setUsers(List<User> users) {
		this.users = users;
	}

	public Set<User> getUserSet() {
		return userSet;
	}

	public void setUserSet(Set<User> userSet) {
		this.userSet = userSet;
	}

	public Map<String, User> getUserMap() {
		return userMap;
	}

	public void setUserMap(Map<String, User> userMap) {
		this.userMap = userMap;
	}

	public Properties getProperties() {
		return properties;
	}

	public void setProperties(Properties properties) {
		this.properties = properties;
	}

	@Override
	public String toString() {
		return "UserInfo [users=" + users + ", userSet=" + userSet + ", userMap=" + userMap + ", properties="
				+ properties + "]";
	}
	
	public void sayHello(){
		System.out.println("hello userInfo");
	}

}
