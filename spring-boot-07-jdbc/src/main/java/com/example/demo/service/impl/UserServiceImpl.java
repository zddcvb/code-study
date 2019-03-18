package com.example.demo.service.impl;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.example.demo.bean.User;
import com.example.demo.mapper.UserMapper;
import com.example.demo.service.UserService;

@Service
public class UserServiceImpl implements UserService {
	@Autowired
	private UserMapper userMapper;

	@Override
	public List<User> findAll() {
		return userMapper.findAll();
	}

	@Override
	public User findById(int id) {
		return userMapper.findById(id);
	}

	@Override
	public void insert(User user) {
		userMapper.insert(user);
	}

	@Override
	public void update(User user) {
		userMapper.update(user);
	}

	@Override
	public void delete(int id) {
		userMapper.delete(id);
	}

	@Override
	public void deteteAll() {
		userMapper.deteteAll();
	}

}
