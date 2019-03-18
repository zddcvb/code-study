package com.jdbc.main;

import javax.xml.crypto.Data;

public class Person {
	private int person_id;
	private String name;
	private int age;
	private String birthday;

	public int getPerson_id() {
		return person_id;
	}

	public void setPerson_id(int person_id) {
		this.person_id = person_id;
	}

	public String getName() {
		return name;
	}

	public void setName(String name) {
		this.name = name;
	}

	public int getAge() {
		return age;
	}

	public void setAge(int age) {
		this.age = age;
	}

	public String getBirthday() {
		return birthday;
	}

	public void setBirthday(String birthday) {
		this.birthday = birthday;
	}

	@Override
	public String toString() {
		return "Person [person_id=" + person_id + ", name=" + name + ", age=" + age + ", birthday=" + birthday + "]";
	}

}
