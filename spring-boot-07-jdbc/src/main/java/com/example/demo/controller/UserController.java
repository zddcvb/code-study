package com.example.demo.controller;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.EnvironmentAware;
import org.springframework.core.env.Environment;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import com.example.demo.bean.User;
import com.example.demo.service.UserService;

@RestController
@RequestMapping("/user")
public class UserController implements EnvironmentAware {
	@Autowired
	private UserService userService;

	@RequestMapping("/list")
	public List<User> list() {
		return userService.findAll();
	}

	@RequestMapping("/findById")
	public User findById(@RequestParam int id) {
		return userService.findById(id);
	}

	@RequestMapping("/insert")
	public boolean insert() {
		for (int i = 1; i < 10; i++) {
			User user = new User(i, "mary_" + i, 30 + i);
			userService.insert(user);
		}
		return true;
	}

	@RequestMapping("/update")
	public boolean update() {
		User user = new User(2, "lucy", 20);
		userService.update(user);
		return true;
	}

	@RequestMapping("/delete")
	public boolean delete(@RequestParam int id) {
		userService.delete(id);
		return true;
	}

	@RequestMapping("/deleteAll")
	public boolean deleteAll() {
		userService.deteteAll();
		return true;
	}

	@Override
	public void setEnvironment(Environment environment) {
		String property = environment.getProperty("JAVA_HOME");
		System.out.println("UserController:" + property);
	}
}
