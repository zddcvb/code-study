package com.jollyclass.test;

import java.util.List;

import org.hibernate.Query;
import org.hibernate.SessionFactory;
import org.junit.Test;
import org.springframework.context.ApplicationContext;
import org.springframework.context.support.ClassPathXmlApplicationContext;

import com.jollyclass.bean.User;
import com.jollyclass.dao.UserDao;

public class SpringTest {
	private ApplicationContext context = new ClassPathXmlApplicationContext("applicationContext.xml");
	// ≤‚ ‘sessionFactory
	@Test
	public void testSessionFactory() {
		SessionFactory factory = (SessionFactory) new ClassPathXmlApplicationContext("applicationContext.xml")
				.getBean("sessionFactory");
		System.out.println(factory.openSession());
	}
	//≤‚ ‘ ¬ŒÒ
	@Test
	public void testTransaction() {
		SessionFactory factory = (SessionFactory) new ClassPathXmlApplicationContext("applicationContext.xml")
				.getBean("sessionFactory");
		String hbl = "from User";
		Query query = factory.openSession().createQuery(hbl);
		List<User> users = query.list();
		for (User user : users) {
			System.out.println(user);
		}
	}

	@Test
	public void testFindAll() {
		UserDao userDao = (UserDao) context.getBean("userDao");
		List<User> users = userDao.findAllUsers();
		for (User user : users) {
			System.out.println(user);
		}
	}

	@Test
	public void testFind() {
		UserDao userDao = (UserDao) context.getBean("userDao");
		User user = (User) userDao.findUser(33);
		System.out.println(user);
	}

	@Test
	public void testinsert() {
		UserDao userDao = (UserDao) context.getBean("userDao");
		User user = new User();
		user.setName("hello");
		user.setAge(20);
		userDao.insertUser(user);
	}

	@Test
	public void testUpdate() {
		UserDao userDao = (UserDao) context.getBean("userDao");
		userDao.updateUser(24);
	}

	@Test
	public void testDelete() {
		UserDao userDao = (UserDao) context.getBean("userDao");
		userDao.deleteUser(24);
	}
}
