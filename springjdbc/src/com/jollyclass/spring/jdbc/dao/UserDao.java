package com.jollyclass.spring.jdbc.dao;

import java.util.List;

import com.jollyclass.spring.jdbc.bean.User;

public interface UserDao {
	public User findUser(int id);

	public List<User> findAllUsers();

	public void insertUser(User user);

	public void updateUser(User user);

	public void deleteUser(int id);
}
