package com.jollyclass.bean;

import java.io.Serializable;

public class Person implements Serializable {
	private String username;
	private String password;

	public Person(String username, String password) {
		this.username = username;
		this.password = password;
	}

	public Person() {
	
	}

	public String getUsername() {
		return username;
	}

	public void setUsername(String username) {
		this.username = username;
	}

	public String getPassword() {
		return password;
	}

	public void setPassword(String password) {
		this.password = password;
	}

	@Override
	public String toString() {
		return "Person [username=" + username + ", password=" + password + "]";
	}

}
