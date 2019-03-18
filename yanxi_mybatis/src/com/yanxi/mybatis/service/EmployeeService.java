package com.yanxi.mybatis.service;

import java.util.List;
import java.util.Map;

import com.yanxi.mybatis.pojo.Employee;

public interface EmployeeService {
	public List<Employee> selectAll();
	public List<Employee> selectByIds(int[] ids);
	public Employee selectById(int id);
	public void insert(Employee employee);
	public void update(Employee employee);
	public void delete(int id);
	public List<Employee> selectByList(List<Integer> ids);
	public List<Employee> selectByMap(Map<String,Object> ids);
}
