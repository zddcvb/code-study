package com.example.demo.service.impl;

import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.jdbc.core.RowMapper;
import org.springframework.stereotype.Service;

import com.example.demo.bean.Person;
import com.example.demo.service.PersonService;

@Service
public class PersonServiceImpl implements PersonService {
	@Autowired
	private JdbcTemplate template;

	@Override
	public List<Person> findAll() {
		String sql = "select * from demo";
		List<Person> list = template.query(sql, new RowMapper<Person>() {

			@Override
			public Person mapRow(ResultSet rs, int rowNum) throws SQLException {
				Person person = new Person();
				person.setId(rs.getInt("id"));
				person.setName(rs.getString("name"));
				person.setAge(rs.getInt("age"));
				return person;
			}

		});
		return list;
	}

}
