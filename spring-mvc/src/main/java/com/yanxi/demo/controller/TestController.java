package com.yanxi.demo.controller;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;

@Controller
public class TestController {
	@RequestMapping("/test")
	public String test() {

		return "index";
	}

	@RequestMapping("/test1")
	public String test1() {

		return "/dept/dept_list";
	}
}
