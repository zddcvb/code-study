package com.yanxi.ioc.service.impl;

import java.util.ArrayList;
import java.util.List;

import javax.annotation.Resource;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.stereotype.Service;
import org.springframework.transaction.PlatformTransactionManager;
import org.springframework.transaction.TransactionDefinition;
import org.springframework.transaction.TransactionStatus;
import org.springframework.transaction.support.DefaultTransactionDefinition;

import com.yanxi.ioc.bean.Student;
import com.yanxi.ioc.service.JdbcService;
import com.yanxi.ioc.util.StudentMapper;
@Service
public class JdbcServiceImpl implements JdbcService {
	@Autowired
	private JdbcTemplate template;
	@Autowired
	private PlatformTransactionManager transactionManager;

	@Override
	public List<Student> findAll() {
		String sql = "select * from demo";
		List<Student> list = template.query(sql, new StudentMapper());
		return list;
	}

	@Override
	public Student findById(int id) {
		String sql = "select * from demo where id=?";
		Student student = template.queryForObject(sql, new Object[] { id }, new StudentMapper());
		return student;
	}

	public List<Student> findByIds(int[] ids) {
		List<Student> students = new ArrayList<>();
		for (int i : ids) {
			Student student = findById(i);
			students.add(student);
		}
		System.out.println(students);
		return students;
	}

	@Override
	public void insert(Student student) {
		TransactionDefinition tranaction=new DefaultTransactionDefinition();
		TransactionStatus status = transactionManager.getTransaction(tranaction);
		String sql = "insert into demo values(" + student.getId() + ",\'" + student.getName() + "\'," + student.getAge()
				+ ")";
		System.out.println(sql);
		template.execute(sql);
		transactionManager.commit(status);
	}

	@Override
	public void update(Student student) {
		String sql = "UPDATE demo SET NAME=?,age=? WHERE id=?";
		template.update(sql, student.getName(), student.getAge(), student.getId());
	}

	@Override
	public void delete(int id) {
		String sql = "delete from demo where id=?";
		template.update(sql, id);
	}

}
