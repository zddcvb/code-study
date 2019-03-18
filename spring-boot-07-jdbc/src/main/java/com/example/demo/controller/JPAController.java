package com.example.demo.controller;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.example.demo.Dao.JAPDao;
import com.example.demo.bean.Student;

@Controller
@RequestMapping("/student")
public class JPAController {
	@Autowired
	private JAPDao dao;

	@RequestMapping("/list")
	@ResponseBody
	public List<Student> getList() {
		List<Student> list = dao.getList();
		return list;
	}

	@RequestMapping("/insert")
	@ResponseBody
	public boolean insert() {
		for (int i = 1; i < 10; i++) {
			System.out.println("====insert====");
			dao.insert(i, "mary_" + i, 20 + i);
		}
		return true;
	}

	@RequestMapping("/delete")
	@ResponseBody
	public boolean delete(@RequestParam int id) {
		dao.delete(id);
		return true;
	}

	@RequestMapping("/update")
	@ResponseBody
	public boolean update(@RequestParam int id) {
		dao.update(id, "lucy", 30);
		return true;
	}

	@RequestMapping("/deleteAll")
	@ResponseBody
	public boolean deleteAll() {
		dao.deleteAll();
		return true;
	}

	@RequestMapping("/findById")
	@ResponseBody
	public Student findById(@RequestParam int id) {
		Student student = dao.findById(id);
		return student;
	}
}
