package com.yanxi.ioc.bean;

public class Person2 {
	private Student student;
 

	public Person2(Student student) {
		this.student = student;
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
	}
}
