package com.yanxi.ioc.service;

import java.util.List;

import com.yanxi.ioc.bean.Student;

public interface JdbcService {
	public List<Student> findAll();

	public Student findById(int id);

	public void insert(Student student);

	public void update(Student student);

	public void delete(int id);

	public List<Student> findByIds(int[] ids);
}
