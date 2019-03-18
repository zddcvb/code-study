package com.jollycalss.bean;

public class Account {
	private int id;
	private String name;
	private long money;
	@Override
	public String toString() {
		return "Account [id=" + id + ", name=" + name + ", money=" + money + "]";
	}
	public int getId() {
		return id;
	}
	public void setId(int id) {
		this.id = id;
	}
	public String getName() {
		return name;
	}
	public void setName(String name) {
		this.name = name;
	}
	public long getMoney() {
		return money;
	}
	public void setMoney(long money) {
		this.money = money;
	}
}
