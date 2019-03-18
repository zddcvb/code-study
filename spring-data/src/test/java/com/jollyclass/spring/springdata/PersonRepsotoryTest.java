package com.jollyclass.spring.springdata;

import org.junit.Test;
import org.springframework.context.ApplicationContext;
import org.springframework.context.support.ClassPathXmlApplicationContext;
import com.jollyclass.spring.domain.Person;

public class PersonRepsotoryTest {
	private ApplicationContext context = null;
	private PersonRepsotory personRepsotory = null;
	{
		context = new ClassPathXmlApplicationContext("classpath:applicationContext.xml");
		personRepsotory = (PersonRepsotory) context.getBean(PersonRepsotory.class);
	}

	@Test
	public void testGetByName() {
		Person person = personRepsotory.getByName("mary");
		System.out.println(person);
	}
}
