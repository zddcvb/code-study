package com.jollyclass.test;

import javax.sql.DataSource;

import org.apache.log4j.helpers.ThreadLocalMap;
import org.junit.Test;
import org.springframework.context.ApplicationContext;
import org.springframework.context.support.ClassPathXmlApplicationContext;
import org.springframework.jdbc.datasource.DataSourceTransactionManager;
import org.springframework.jdbc.datasource.DriverManagerDataSource;
import org.springframework.transaction.TransactionStatus;
import org.springframework.transaction.support.TransactionCallback;
import org.springframework.transaction.support.TransactionTemplate;

public class TestJDBC {
	@Test
	public void testcreate() {
		ApplicationContext context = new ClassPathXmlApplicationContext("applicationContext.xml");
		JDBCTest3 jDBCTest3 = (JDBCTest3) context.getBean("JDBCTest3");
		jDBCTest3.testCreate();
	}

	@Test
	public void testcreate1() {
		ApplicationContext context = new ClassPathXmlApplicationContext("applicationContext.xml");
		JDBCTest3 jDBCTest3 = (JDBCTest3) context.getBean("JDBCTest3");
		jDBCTest3.testCreate();
	}

	@Test
	public void testcreate2() {
		ApplicationContext context = new ClassPathXmlApplicationContext("applicationContext.xml");
		JDBCTest3 jDBCTest3 = (JDBCTest3) context.getBean("JDBCTest3");
		jDBCTest3.testCreate();
	}

	@Test
	public void testTransaction() {
		DriverManagerDataSource dataSource = new DriverManagerDataSource();
		DataSourceTransactionManager transactionManager = new DataSourceTransactionManager(dataSource);
		//通过此api进行事务操作
		TransactionTemplate template = new TransactionTemplate(transactionManager);
		template.execute(new TransactionCallback<Object>() {

			@Override
			public Object doInTransaction(TransactionStatus arg0) {
				//输入要执行的操作
				return null;
			}
		});
	}
}
