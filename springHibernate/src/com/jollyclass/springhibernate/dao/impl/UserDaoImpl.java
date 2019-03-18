package com.jollyclass.springhibernate.dao.impl;

import java.util.List;

import org.hibernate.Query;
import org.hibernate.SessionFactory;
import org.hibernate.Transaction;
import org.hibernate.classic.Session;
import org.springframework.context.ApplicationContext;
import org.springframework.context.support.ClassPathXmlApplicationContext;

import com.jollyclass.springhibernate.bean.User;
import com.jollyclass.springhibernate.dao.UserDao;

public class UserDaoImpl implements UserDao {
	public SessionFactory getSeesionFactory() {
		ApplicationContext context = new ClassPathXmlApplicationContext("spring-module.xml");
		;
		return (SessionFactory)context.getBean("sessionFactory");
	}

	@Override
	public User findUser(int id) {
		Session session = getSeesionFactory().getCurrentSession();
		Transaction tc = session.beginTransaction();
		User user = (User) session.get(User.class, id);
		// System.out.println(user);
		tc.commit();
		session.close();
		return null;
	}

	@Override
	public List<User> findAllUsers() {
		Session session = getSeesionFactory().getCurrentSession();
		Transaction tc = session.beginTransaction();
		String hbl = "from User";
		Query query = session.createQuery(hbl);
		List<User> lists = query.list();

		tc.commit();
		session.close();
		return lists;
	}

	@Override
	public void insertUser(User user) {
		Session session = getSeesionFactory().getCurrentSession();
		Transaction tc = session.beginTransaction();
		session.save(user);
		tc.commit();
		session.close();
	}

	@Override
	public void updateUser(int id) {
		Session session = getSeesionFactory().getCurrentSession();
		Transaction tc = session.beginTransaction();
		User user = (User) session.get(User.class, id);
		user.setName("’≈…∫");
		user.setAge(20);
		session.update(user);
		tc.commit();
		session.close();
	}

	@Override
	public void deleteUser(int id) {
		Session session = getSeesionFactory().getCurrentSession();
		Transaction tc = session.beginTransaction();
		User user = (User) session.get(User.class, id);
		session.delete(user);
		tc.commit();
		session.close();
	}

}
