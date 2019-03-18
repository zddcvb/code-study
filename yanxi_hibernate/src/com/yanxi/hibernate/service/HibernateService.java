package com.yanxi.hibernate.service;

import java.util.List;
import com.yanxi.hibernate.pojo.TestBean;

public interface HibernateService {
	public List<TestBean> findAll();

	public List<TestBean> findByIds(Integer[] ids);

	public TestBean findById(int id);

	public Boolean insert(TestBean testBean);

	public Boolean update(TestBean testBean);

	public Boolean delete(int id);
}
