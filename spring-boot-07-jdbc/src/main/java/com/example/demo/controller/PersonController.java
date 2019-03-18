package com.example.demo.controller;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import com.example.demo.bean.Person;
import com.example.demo.service.PersonService;

@Controller
public class PersonController {
	@Autowired
	private PersonService personService;

	@RequestMapping("/person")
	@ResponseBody
	public List<Person> getList() {
		List<Person> list = personService.findAll();
		System.out.println(list);
		return list;
	}
}
