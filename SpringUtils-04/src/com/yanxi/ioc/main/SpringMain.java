package com.yanxi.ioc.main;

import java.util.List;
import org.springframework.context.ApplicationContext;
import org.springframework.context.support.ClassPathXmlApplicationContext;
import com.yanxi.ioc.bean.Student;
import com.yanxi.ioc.service.JdbcService;

public class SpringMain {
	public static void main(String[] args) {
		ApplicationContext context = new ClassPathXmlApplicationContext("bean2.xml");
		JdbcService jdbcServiceImpl = (JdbcService) context.getBean("jdbcServiceImpl");
		//插入数据
		jdbcServiceImpl.insert(new Student(2, "mary", 20));
		//查询所有的数据
		List<Student> list = jdbcServiceImpl.findAll();
		//根据数组查询数据
		List<Student> lists = jdbcServiceImpl.findByIds(new int[]{1,2});
		System.out.println(list);
		// 根据id查找
		  Student student = jdbcServiceImpl.findById(1);
		  System.out.println(student);
		// 更新数据
		Student student1 = new Student(1, "lucy", 30);
		 jdbcServiceImpl.update(student1);
		// 删除数据
		 jdbcServiceImpl.delete(1);
	}
}
