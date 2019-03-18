package com.yanxi.hibernate.dao.impl;

import java.util.List;
import org.hibernate.Session;
import org.hibernate.SessionFactory;
import org.hibernate.Transaction;
import org.hibernate.cfg.Configuration;
import com.yanxi.hibernate.dao.HibernateDao;
import com.yanxi.hibernate.pojo.TestBean;

public class HibernateDaoImpl implements HibernateDao {

	private Session getSession() {
		System.out.println("session start");
		Configuration configuration = new Configuration().configure("hibernate.cfg.xml");
		SessionFactory factory = configuration.buildSessionFactory();
		Session session = factory.openSession();
		System.out.println("session open");
		return session;
	}

	@SuppressWarnings("unchecked")
	@Override
	public List<TestBean> findAll() {
		Session session = getSession();
		String hql = "from TestBean";
		List<TestBean> list = session.createQuery(hql).list();
		for (TestBean testBean : list) {
			System.out.println(testBean);
		}
		return list;
	}

	@SuppressWarnings("unchecked")
	@Override
	public List<TestBean> findByIds(Integer[] ids) {
		Session session = getSession();
		String hql = " from TestBean tb where tb.id in (:ids)";
		List<TestBean> list = session.createQuery(hql).setParameterList("ids", ids).list();
		return list;
	}

	@Override
	public TestBean findById(int id) {
		Session session = getSession();
		TestBean testBean = (TestBean) session.get(TestBean.class, id);
		return testBean;
	}

	@Override
	public Boolean insert(TestBean testBean) {
		Session session = getSession();
		Transaction transaction = session.beginTransaction();
		session.save(testBean);
		transaction.commit();
		session.close();
		return true;
	}

	@Override
	public Boolean update(TestBean testBean) {
		Session session = getSession();
		TestBean queryTest = (TestBean) session.get(TestBean.class, testBean.getId());
		System.out.println(queryTest);
		Transaction transaction = session.beginTransaction();
		queryTest.setAge(testBean.getAge());
		queryTest.setName(testBean.getName());
		session.update(queryTest);
		transaction.commit();
		return true;
	}

	@Override
	public Boolean delete(int id) {
		Session session = getSession();
		TestBean queryTest = (TestBean) session.get(TestBean.class, id);
		Transaction transaction = session.beginTransaction();
		session.delete(queryTest);
		transaction.commit();
		return true;
	}

}
