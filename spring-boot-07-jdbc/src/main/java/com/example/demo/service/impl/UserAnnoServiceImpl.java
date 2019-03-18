package com.example.demo.service.impl;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.example.demo.bean.UserAnno;
import com.example.demo.mapper.UserMapperAnno;
import com.example.demo.service.UserAnnoService;

@Service
public class UserAnnoServiceImpl implements UserAnnoService {
	@Autowired
	private UserMapperAnno userMapperAnno;

	@Override
	public List<UserAnno> findAll() {
		return userMapperAnno.findAll();
	}

	@Override
	public UserAnno findById(int id) {
		return userMapperAnno.findById(id);
	}

	@Override
	public void insert(UserAnno userAnno) {
		userMapperAnno.insert(userAnno);
	}

	@Override
	public void update(UserAnno userAnno) {
		userMapperAnno.update(userAnno);
	}

	@Override
	public void delete(int id) {
		userMapperAnno.delete(id);
	}

	@Override
	public void deteteAll() {
		userMapperAnno.deteteAll();
	}

}
