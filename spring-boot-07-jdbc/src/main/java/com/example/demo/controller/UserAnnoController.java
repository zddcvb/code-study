package com.example.demo.controller;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import com.example.demo.bean.UserAnno;
import com.example.demo.service.UserAnnoService;
import com.github.pagehelper.PageHelper;

@RestController
@RequestMapping("/userAnno")
public class UserAnnoController {
	@Autowired
	private UserAnnoService userAnnoService;

	@RequestMapping("/list")
	public List<UserAnno> list() {
		return userAnnoService.findAll();
	}

	@RequestMapping("/findById")
	public UserAnno findById(@RequestParam int id) {
		return userAnnoService.findById(id);
	}

	@RequestMapping("/insert")
	public boolean insert() {
		for (int i = 1; i < 10; i++) {
			UserAnno userAnno = new UserAnno(i, "mary_" + i, 30 + i);
			userAnnoService.insert(userAnno);
		}
		return true;
	}

	@RequestMapping("/update")
	public boolean update() {
		UserAnno userAnno = new UserAnno(2, "lucy", 20);
		userAnnoService.update(userAnno);
		return true;
	}

	@RequestMapping("/delete")
	public boolean delete(@RequestParam int id) {
		userAnnoService.delete(id);
		return true;
	}

	@RequestMapping("/deleteAll")
	public boolean deleteAll() {
		userAnnoService.deteteAll();
		return true;
	}

	@RequestMapping("/page")
	public List<UserAnno> pageHelper(@RequestParam int startIndex, @RequestParam int limit) {
		PageHelper.offsetPage(startIndex, limit);
		return userAnnoService.findAll();
	}
}
