package com.jollyclass.spring.action;

public class UserAction {
	public String name;
	private String age;
	private String phone;

	public String getAge() {
		return age;
	}

	public void setAge(String age) {
		this.age = age;
	}

	public String getPhone() {
		return phone;
	}

	public void setPhone(String phone) {
		this.phone = phone;
	}

	public void printUser() {
		System.out.println("printUser:" + name);
	}

	public void setName(String name) {
		this.name = name;
	}

	@Override
	public String toString() {
		return "UserAction [name=" + name + ", age=" + age + ", phone=" + phone + "]";
	}
	

}
