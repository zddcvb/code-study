package com.jollyclass.dao.impl;

import java.util.List;

import org.hibernate.Query;
import org.hibernate.SessionFactory;
import org.hibernate.classic.Session;

import com.jollyclass.bean.User;
import com.jollyclass.dao.UserDao;

public class UserDaoImpl implements UserDao {
	private SessionFactory sessionFactory;

	public SessionFactory getSessionFactory() {
		return sessionFactory;
	}

	public void setSessionFactory(SessionFactory sessionFactory) {
		this.sessionFactory = sessionFactory;
	}

	@Override
	public User findUser(int id) {
		Session session = sessionFactory.openSession();
		User user = (User) session.get(User.class, id);
		return user;
	}

	@Override
	public List<User> findAllUsers() {
		Session session = sessionFactory.openSession();
		String hbl = "from User";
		Query query = session.createQuery(hbl);
		List<User> lists = query.list();
		return lists;
	}

	@Override
	public void insertUser(User user) {
		Session session = sessionFactory.openSession();
		session.save(user);
	}

	@Override
	public void updateUser(int id) {
		Session session = sessionFactory.openSession();
		User user = (User) session.get(User.class, id);
		user.setName("’≈…∫");
		user.setAge(20);
		session.update(user);
	}

	@Override
	public void deleteUser(int id) {
		Session session = sessionFactory.openSession();
		User user = (User) session.get(User.class, id);
		session.delete(user);
	}

}
