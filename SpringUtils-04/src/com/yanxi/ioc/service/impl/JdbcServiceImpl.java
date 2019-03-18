package com.yanxi.ioc.service.impl;

import java.util.ArrayList;
import java.util.List;

import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.jdbc.datasource.DriverManagerDataSource;

import com.yanxi.ioc.bean.Student;
import com.yanxi.ioc.service.JdbcService;
import com.yanxi.ioc.util.StudentMapper;

public class JdbcServiceImpl implements JdbcService {
	private DriverManagerDataSource dataSource;

	public DriverManagerDataSource getDataSource() {
		return dataSource;
	}

	public void setDataSource(DriverManagerDataSource dataSource) {
		this.dataSource = dataSource;
	}

	public JdbcTemplate getJdbc() {
		JdbcTemplate template = new JdbcTemplate(dataSource);
		return template;
	}

	@Override
	public List<Student> findAll() {
		JdbcTemplate template = getJdbc();
		String sql = "select * from demo";
		List<Student> list = template.query(sql, new StudentMapper());
		return list;
	}

	@Override
	public Student findById(int id) {
		JdbcTemplate template = getJdbc();
		String sql = "select * from demo where id=?";
		Student student = template.queryForObject(sql, new Object[] { id }, new StudentMapper());
		return student;
	}

	public List<Student> findByIds(int[] ids) {
		List<Student> students = new ArrayList<>();
		JdbcTemplate template = getJdbc();
		for (int i : ids) {
			Student student = findById(i);
			students.add(student);
		}
		System.out.println(students);
		return students;
	}

	@Override
	public void insert(Student student) {
		JdbcTemplate template = getJdbc();
		String sql = "insert into demo values(" + student.getId() + ",\'" + student.getName() + "\'," + student.getAge()
				+ ")";
		System.out.println(sql);
		template.execute(sql);
	}

	@Override
	public void update(Student student) {
		JdbcTemplate template = getJdbc();
		String sql = "UPDATE demo SET NAME=?,age=? WHERE id=?";
		template.update(sql, student.getName(), student.getAge(), student.getId());
	}

	@Override
	public void delete(int id) {
		JdbcTemplate template = getJdbc();
		String sql = "delete from demo where id=?";
		template.update(sql, id);
	}

}
