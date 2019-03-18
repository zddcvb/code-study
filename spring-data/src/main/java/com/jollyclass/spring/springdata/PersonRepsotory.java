package com.jollyclass.spring.springdata;

import org.springframework.data.repository.Repository;

import com.jollyclass.spring.domain.Person;

public interface PersonRepsotory extends Repository<Person, Integer> {
	public Person getByName(String name);
}
