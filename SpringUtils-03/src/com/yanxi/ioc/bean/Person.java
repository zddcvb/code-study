package com.yanxi.ioc.bean;

import java.util.List;
import java.util.Map;
import java.util.Properties;
import java.util.Set;

public class Person {
	private Student student;
	private List<Integer> lists;
	private Set<String> sets;
	private Map<String, Integer> maps;
	private Properties properties;
 	public Person() {
		super();
	}

	public Person(Student student) {
		this.student = student;
	}

	public Student getStudent() {
		return student;
	}

	public void setStudent(Student student) {
		this.student = student;
	}

	public List<Integer> getLists() {
		return lists;
	}

	public void setLists(List<Integer> lists) {
		this.lists = lists;
	}

	public Set<String> getSets() {
		return sets;
	}

	public void setSets(Set<String> sets) {
		this.sets = sets;
	}

	public Map<String, Integer> getMaps() {
		return maps;
	}

	public void setMaps(Map<String, Integer> maps) {
		this.maps = maps;
	}

	public Properties getProperties() {
		return properties;
	}

	public void setProperties(Properties properties) {
		this.properties = properties;
	}

	public void say() {
		System.out.println(student);
		student.say();
		System.out.println(this.lists);
		System.out.println(this.sets);
		System.out.println(this.properties);
		System.out.println(this.maps);
	}
}
