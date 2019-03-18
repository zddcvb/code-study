package com.yanxi.hibernate.service.impl;

import java.util.List;
import com.yanxi.hibernate.dao.HibernateDao;
import com.yanxi.hibernate.dao.impl.HibernateDaoImpl;
import com.yanxi.hibernate.pojo.TestBean;
import com.yanxi.hibernate.service.HibernateService;

public class HibernateServiceImpl implements HibernateService {
	private HibernateDao hibernateDao = new HibernateDaoImpl();

	@Override
	public List<TestBean> findAll() {
		return hibernateDao.findAll();
	}

	@Override
	public List<TestBean> findByIds(Integer[] ids) {
		return hibernateDao.findByIds(ids);
	}

	@Override
	public TestBean findById(int id) {
		return hibernateDao.findById(id);
	}

	@Override
	public Boolean insert(TestBean testBean) {
		return hibernateDao.insert(testBean);
	}

	@Override
	public Boolean update(TestBean testBean) {
		return hibernateDao.update(testBean);
	}

	@Override
	public Boolean delete(int id) {
		return hibernateDao.delete(id);
	}

}
