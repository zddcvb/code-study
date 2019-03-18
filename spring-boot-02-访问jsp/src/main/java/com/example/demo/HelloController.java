package com.example.demo;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

@RestController
public class HelloController {
	@RequestMapping("/index")
	public String index() {
		return "hello index";
	}

	@RequestMapping("/info")
	public Map<String, String> info(@RequestParam String name) {
		Map<String, String> info = new HashMap<>();
		info.put("name", name);
		return info;
	}
	@RequestMapping("/list")
	public List<Map<String, String>> list() {
		List<Map<String, String>> list = new ArrayList<>();
		for (int i = 0; i < 10; i++) {
			Map<String, String> map = new HashMap<>();
			map.put("name", "jack" + i);
			list.add(map);
		}
		return list;
	}
}
