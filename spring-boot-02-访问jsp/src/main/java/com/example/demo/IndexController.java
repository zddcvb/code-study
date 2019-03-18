package com.example.demo;

import java.util.Date;
import java.util.Map;

import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.servlet.ModelAndView;

@Controller
public class IndexController {
	@Value("${application.hello}")
	private String hello;

	@RequestMapping("/")
	public String index(Map<String, Object> model) {
		model.put("time", new Date());
		model.put("message", this.hello);
		return "index";
	}

	@RequestMapping("/page1")
	public ModelAndView page() {
		ModelAndView model = new ModelAndView("page/page1");
		model.addObject("content", hello);
		return model;
	}

	@RequestMapping("/page2")
	public Model page2(Model model) {
		model.addAttribute("content", hello + " next");
		return model;
	}
}
