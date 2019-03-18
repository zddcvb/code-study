package com.yanxi.hibernate.test;

import java.util.List;
import org.junit.Test;
import com.yanxi.hibernate.pojo.TestBean;
import com.yanxi.hibernate.service.HibernateService;
import com.yanxi.hibernate.service.impl.HibernateServiceImpl;

public class HibernateTest {
	private HibernateService service=new HibernateServiceImpl();

	@Test
	public void test_insert() {
		for (int i = 1; i < 15; i++) {
			service.insert(new TestBean(i, "mary" + i, 15 + i));
		}
	}

	@Test
	public void test_udpate() {
		TestBean testBean=new TestBean(2,"lucy",25);
		service.update(testBean);
	}

	@Test
	public void test_delete() {
		service.delete(3);
	}

	@Test
	public void test_findAll() {
		List<TestBean> list = service.findAll();
		System.out.println(list);
	}

	@Test
	public void test_findById() {
		TestBean testBean = service.findById(2);
		System.out.println(testBean);
	}

	@Test
	public void test_findByIds() {
		Integer[] ids={5,6,7};
		List<TestBean> list = service.findByIds(ids);
		System.out.println(list);
	}

	@Test
	public void test_findByList() {
		
	}
}
