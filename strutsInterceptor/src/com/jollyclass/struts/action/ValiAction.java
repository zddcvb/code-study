package com.jollyclass.struts.action;

import com.jollyclass.bean.Person;
import com.opensymphony.xwork2.ActionContext;
import com.opensymphony.xwork2.ActionSupport;
import com.opensymphony.xwork2.ModelDriven;

public class ValiAction extends ActionSupport implements ModelDriven<Person> {
	private Person person = new Person();

	public String getMessage() {
		ActionContext.getContext().put("person", person);
		return "validate";
	}

	@Override
	public void validate() {
		person = getModel();
		if (!"admin".equals(person.getUsername())) {
			this.addActionError("username is error,please input again!!!");
		}
	}

	@Override
	public Person getModel() {
		return person;
	}

}
