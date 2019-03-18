package com.jollyclass.struts.action;

import java.awt.List;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.Map;
import java.util.concurrent.ConcurrentHashMap;

import com.jollyclass.bean.Person;
import com.opensymphony.xwork2.ActionContext;
import com.opensymphony.xwork2.ActionSupport;
import com.opensymphony.xwork2.util.ValueStack;
import com.sun.xml.internal.bind.v2.runtime.unmarshaller.XsiNilLoader.Array;

public class InterotAction extends ActionSupport {
	public String getList() {
		Person person1 = new Person("jack", "123");
		Person person2 = new Person("lucy", "5465");
		Person person3 = new Person("mary", "737837");
		ArrayList<Person> persons = new ArrayList<Person>();
		persons.add(person1);
		persons.add(person2);
		persons.add(person3);
		// ActionContext.getContext().getValueStack().push(persons);
		ActionContext.getContext().put("persons", persons);
		return "list";
	}

	public String geMap() {
		Person person1 = new Person("jack", "123");
		Person person2 = new Person("lucy", "5465");
		Person person3 = new Person("mary", "737837");
		Map<String, Person> persons = new HashMap<String, Person>();
		persons.put("1", person1);
		persons.put("2", person2);
		persons.put("3", person3);
		// ActionContext.getContext().getValueStack().push(persons);
		ActionContext.getContext().put("persons", persons);
		@SuppressWarnings("unused")
		ValueStack valueStack = ActionContext.getContext().getValueStack();
		return "list";
	}

	public String getArray() {
		Person person1 = new Person("jack", "1000003");
		Person person2 = new Person("lucy", "546000005");
		Person person3 = new Person("mary", "7370000837");
		Person[] persons = new Person[] { person1, person2, person3 };
		// ActionContext.getContext().getValueStack().push(persons);
		ActionContext.getContext().put("persons", persons);
		return "list";
	}

	public String getListMap() {
		Person person1 = new Person("jack", "123");
		Person person2 = new Person("lucy", "5465");
		Person person3 = new Person("mary", "737837");
		Map<String, Person> persons = new HashMap<String, Person>();
		persons.put("1", person1);
		persons.put("2", person2);
		persons.put("3", person3);
		ArrayList<Map<String, Person>> lists = new ArrayList<Map<String, Person>>();
		lists.add(persons);
		ActionContext.getContext().getValueStack().push(lists);
		// ActionContext.getContext().put("lists", lists);
		return "list";
	}

	// 在map中包含list
	public String getMapList() {
		Person person1 = new Person("jack", "111111");
		Person person2 = new Person("lucy", "22222");
		Person person3 = new Person("mary", "33333");
		ArrayList<Person> persons = new ArrayList<Person>();
		persons.add(person1);
		persons.add(person2);
		persons.add(person3);
		Map<String, ArrayList<Person>> maps = new HashMap<String, ArrayList<Person>>();
		maps.put("map", persons);
		// ActionContext.getContext().getValueStack().push(maps);
		ActionContext.getContext().put("maps", maps);
		return "list";
	}

	// map中包含list，list中包含map
	public String getMapListMap() {
		Person person1 = new Person("jack", "7777");
		Person person2 = new Person("lucy", "222288882");
		Person person3 = new Person("mary", "333366663");
		ArrayList<Map<String, Person>> persons = new ArrayList<Map<String, Person>>();
		Map<String, Person> newPersons = new HashMap<String, Person>();
		newPersons.put("person1", person1);
		newPersons.put("person2", person2);
		newPersons.put("person3", person3);
		persons.add(newPersons);
		Map<String, ArrayList<Map<String, Person>>> maps = new HashMap<String, ArrayList<Map<String, Person>>>();
		maps.put("map", persons);
		// ActionContext.getContext().getValueStack().push(maps);
		ActionContext.getContext().put("maps", maps);
		return "list";
	}

	// list中包含map，map中包含list
	public String getListMapList() {
		Person person1 = new Person("jack", "avagdgw");
		Person person2 = new Person("lucy", "2222888gwaegw037082");
		Person person3 = new Person("mary", "webwg");
		ArrayList<Person> persons = new ArrayList<Person>();
		Map<String, ArrayList<Person>> newPersons = new HashMap<String, ArrayList<Person>>();
		persons.add(person1);
		persons.add(person2);
		persons.add(person3);
		newPersons.put("persons", persons);
		ArrayList<Map<String, ArrayList<Person>>> lists = new ArrayList<Map<String, ArrayList<Person>>>();
		lists.add(newPersons);
		ActionContext.getContext().getValueStack().push(lists);
		// ActionContext.getContext().put("lists", lists);
		return "list";
	}
}
