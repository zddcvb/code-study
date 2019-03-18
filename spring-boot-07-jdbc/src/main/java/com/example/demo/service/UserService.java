package com.example.demo.service;

import java.util.List;

import com.example.demo.bean.User;

public interface UserService {
	public List<User> findAll();

	public User findById(int id);

	public void insert(User user);

	public void update(User user);

	public void delete(int id);

	public void deteteAll();
}
