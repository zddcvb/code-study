package com.jollyclass.struts.action;

import com.jollyclass.bean.Person;
import com.opensymphony.xwork2.ActionContext;
import com.opensymphony.xwork2.ActionSupport;
import com.opensymphony.xwork2.ModelDriven;

public class ModelAction extends ActionSupport implements ModelDriven<Person> {
	private Person person = new Person();

	@Override
	public Person getModel() {
		// TODO Auto-generated method stub
		return person;
	}

	public String getPerson() {
		person = getModel();
		if ("admin".equals(person.getUsername())) {
			ActionContext.getContext().put("message", person.toString());
		}else{
			ActionContext.getContext().put("message", "username don't exist!!!");
		}
		return "person";
	}
}
