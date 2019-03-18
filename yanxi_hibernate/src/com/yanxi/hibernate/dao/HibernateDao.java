package com.yanxi.hibernate.dao;

import java.util.List;
import com.yanxi.hibernate.pojo.TestBean;

public interface HibernateDao {
	public List<TestBean> findAll();

	public List<TestBean> findByIds(Integer[] ids);

	public TestBean findById(int id);

	public Boolean insert(TestBean testBean);

	public Boolean update(TestBean testBean);

	public Boolean delete(int id);
}
