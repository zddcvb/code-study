package com.jollyclass.spring.jdbc.test;

import org.junit.Test;

import com.jollyclass.spring.jdbc.action.UserAction;

public class UserTest {
	@Test
	public void testFindAll() {
		UserAction action = new UserAction();
		action.testFindAllUsers();
	}

	@Test
	public void testFindUser() {
		UserAction action = new UserAction();
		action.testFindUserById();
	}

	@Test
	public void testinsertUser() {
		UserAction action = new UserAction();
		action.testinsertUser();
	}
	
	@Test
	public void testUpdateUser() {
		UserAction action = new UserAction();
		action.testupdateUser();
	}
	
	@Test
	public void testDelete() {
		UserAction action = new UserAction();
		action.testDeleteUser();
	}
	
	
}
