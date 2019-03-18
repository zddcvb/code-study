package com.yanxi.mybatis.test;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import org.junit.Test;
import com.yanxi.mybatis.pojo.Employee;
import com.yanxi.mybatis.service.EmployeeService;
import com.yanxi.mybatis.service.impl.EmployeeServiceImpl;

public class EmployeeTest {
	@Test
	public void test_selectAll() {
		EmployeeService service = new EmployeeServiceImpl();
		service.selectAll();
	}

	@Test
	public void test_selectById() {
		EmployeeService service = new EmployeeServiceImpl();
		Employee employee = service.selectById(5);
		System.out.println(employee);
	}

	@Test
	public void test_selectByIds() {
		int[] ids = { 1, 2, 5, 4 };
		EmployeeService service = new EmployeeServiceImpl();
		List<Employee> list = service.selectByIds(ids);
		System.out.println(list);
	}

	@Test
	public void test_selectByList() {
		List<Integer> ids = new ArrayList<>();
		ids.add(1);
		ids.add(2);
		ids.add(5);
		ids.add(4);
		EmployeeService service = new EmployeeServiceImpl();
		List<Employee> list = service.selectByList(ids);
		System.out.println(list);
	}

	@Test
	public void test_selectByMap() {
		Map<String, Object> ids = new HashMap<>();
		int[] arrs = { 1, 2, 5, 4 };
		ids.put("ids", arrs);
		EmployeeService service = new EmployeeServiceImpl();
		List<Employee> list = service.selectByMap(ids);
		System.out.println(list);
	}

	@Test
	public void test_insert() {
		EmployeeService service = new EmployeeServiceImpl();
		for (int i = 0; i < 15; i++) {
			service.insert(new Employee(i + 1, "张珊+" + (i + 1), 15 + i));
		}
	}

	@Test
	public void test_update() {
		EmployeeService service = new EmployeeServiceImpl();
		service.update(new Employee(2, "李四", 30));
	}

	@Test
	public void test_delete() {
		EmployeeService service = new EmployeeServiceImpl();
		service.delete(3);
	}
}
