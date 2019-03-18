package com.jollyclass.struts.action;

import java.util.HashMap;
import java.util.Map;

import org.apache.struts2.ServletActionContext;
import org.apache.struts2.dispatcher.ApplicationMap;
import org.apache.struts2.dispatcher.RequestMap;
import org.apache.struts2.dispatcher.SessionMap;
import com.opensymphony.xwork2.ActionContext;
import com.opensymphony.xwork2.ActionSupport;
import com.opensymphony.xwork2.util.CompoundRoot;
import com.opensymphony.xwork2.util.ValueStack;

@SuppressWarnings({ "unchecked", "serial", "unused" })
public class ActionDemo1 extends ActionSupport {
	public String getValueStack() {
		ValueStack valueStack = ActionContext.getContext().getValueStack();
		ValueStack valueStack2 = ServletActionContext.getContext().getValueStack();
		ValueStack valueStack3 = (ValueStack) ServletActionContext.getRequest().getAttribute("struts.valueStack");
		System.out.println(valueStack.hashCode());
		System.out.println(valueStack2.hashCode());
		System.out.println(valueStack3.hashCode());
		return "Success";
	}

	public String getValueStack_1() {
		ValueStack valueStack = ActionContext.getContext().getValueStack();
		return "Success";
	}

	public String getObject() {
		ValueStack valueStack = ActionContext.getContext().getValueStack();
		// 获取_values
		Map<String, Object> values = valueStack.getContext();
		// 获取request、application、session、action的值
		RequestMap request = (RequestMap) values.get("request");
		ApplicationMap application = (ApplicationMap) values.get("application");
		SessionMap<Object, Object> session = (SessionMap<Object, Object>) values.get("session");
		ActionDemo1 demo1 = (ActionDemo1) values.get("action");
		// 获取root对象，对象栈
		CompoundRoot root = valueStack.getRoot();
		return "Success";
	}

	// 添加元素到栈顶
	public String addObjectToRoot() {
		ValueStack valueStack = ActionContext.getContext().getValueStack();
		valueStack.push("hello");
		valueStack.getRoot().add(0, "struts4");
		//将map放置到栈底
		valueStack.getRoot().add("hello");
		return "Success";
	}
	//删除栈顶元素
	public String removeObjectToRoot() {
		ValueStack valueStack = ActionContext.getContext().getValueStack();
		valueStack.getRoot().remove(0);
		valueStack.pop();
		return "Success";
	}
	public String getRoot(){
		ValueStack valueStack = ActionContext.getContext().getValueStack();
		//获取栈顶元素
		valueStack.peek();
		Object object = valueStack.getRoot().get(0);
		return "Success";
	}
	public String addMapToRoot() {
		Map<String, String> map=new HashMap<String ,String>();
		map.put("1", "name");
		map.put("2", "age");
		ValueStack valueStack = ActionContext.getContext().getValueStack();
		CompoundRoot root = valueStack.getRoot();
		//将map放置到栈顶
		root.set(0, map);
		//将map放置到栈底
		root.add(map);
		//将对象放置到栈顶
		root.add(0, "struts4");
		System.out.println(root.size());
		return "Success";
	}
	public String addObjectToContext(){
		ServletActionContext.getRequest().setAttribute("name", "lucy");
		ServletActionContext.getServletContext().setAttribute("age", "20");
		ServletActionContext.getRequest().getSession().setAttribute("id", "2");
		ValueStack valueStack = ActionContext.getContext().getValueStack();
		String attribute = (String) ServletActionContext.getServletContext().getAttribute("age");
		System.out.println(attribute);
		return "Success";
	}
	public String addObjectToMap(){
		ValueStack valueStack = ActionContext.getContext().getValueStack();
		valueStack.getContext().put("class", "class2");
		return "Success";
	}
	
	public String displayObjectToRoot(){
		ValueStack valueStack = ActionContext.getContext().getValueStack();
		//valueStack.push("欢迎进入struts2");
		Person person=new Person();
		person.setName("lucy");
		person.setAge(20);
		valueStack.push(person);
		valueStack.getContext().put("person", person);
		ServletActionContext.getRequest().setAttribute("persons", person);
		return "Success";
	}
	
}
