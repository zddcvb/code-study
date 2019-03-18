package com.jollyclass.test;

import org.junit.Test;
import org.springframework.context.ApplicationContext;
import org.springframework.context.support.ClassPathXmlApplicationContext;

import com.jollyclass.service.AccountService;

public class AccountTest {

	public AccountService getAccountService() {
		ApplicationContext context = new ClassPathXmlApplicationContext("applicationContext2.xml");
		AccountService accountService = (AccountService) context.getBean("accountService");
		return accountService;
	}

	@Test
	public void testAccout() {
		getAccountService().tranfer("a", "b", 200);
	}
}
