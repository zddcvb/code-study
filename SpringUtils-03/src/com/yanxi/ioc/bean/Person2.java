package com.yanxi.ioc.bean;

public class Person2 {
	private Student student;
	private String name;

	public Person2() {
		super();
	}
	public String getName() {
		return name;
	}

	public void setName(String name) {
		this.name = name;
	}



	public Person2(Student student, String name) {
		super();
		this.student = student;
		this.name = name;
	}



	public Student getStudent() {
		return student;
	}

	public void setStudent(Student student) {
		this.student = student;
	}

	

	public void say() {
		System.out.println(student);
		student.say();
		System.out.println(name);
	}
}
