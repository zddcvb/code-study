package com.example.demo.Dao;

import java.util.List;

import javax.transaction.Transactional;

import org.springframework.data.jpa.repository.Modifying;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.CrudRepository;

import com.example.demo.bean.Student;

public interface JAPDao extends CrudRepository<Student, Integer> {
	@Query("select s from Student s")
	public List<Student> getList();

	@Query(value = "select * from Student s where s.id=?1", nativeQuery = true)
	public Student findById(int id);

	@Transactional
	@Modifying
	@Query(value = "insert into Student  values (?1,?2,?3)", nativeQuery = true)
	public void insert(int id, String name, int age);

	@Transactional
	@Modifying
	@Query(value = "update Student s set s.name=?2,s.age=?3 where s.id=?1", nativeQuery = true)
	public void update(int id, String name, int age);

	@Transactional
	@Modifying
	@Query(value = "delete Student s where s.id=?1", nativeQuery = true)
	public void delete(int id);

	@Transactional
	@Modifying
	@Query("delete from Student")
	public void deleteAll();
}
