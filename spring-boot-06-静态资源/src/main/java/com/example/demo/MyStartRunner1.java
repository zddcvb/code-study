package com.example.demo;

import org.springframework.boot.CommandLineRunner;
import org.springframework.core.annotation.Order;
import org.springframework.stereotype.Component;

@Component
@Order(value = 2)
public class MyStartRunner1 implements CommandLineRunner {

	@Override
	public void run(String... args) throws Exception {
		System.out.println("==============MyStartRunner1 run=================");
	}

}
