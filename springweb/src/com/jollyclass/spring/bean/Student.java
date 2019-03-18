package com.jollyclass.spring.bean;

import java.text.SimpleDateFormat;
import java.util.Date;

public class Student {
	private Date date;

	public Date getDate() {
		return date;
	}

	public void setDate(Date date) {
		this.date = date;
	}

	@Override
	public String toString() {
		return "Student [date=" + date + "]";
	}
	public void printDate(){
		SimpleDateFormat format=new SimpleDateFormat("yyyy-MM-DD");
		System.out.println(format.format(new Date()));
	}
}
