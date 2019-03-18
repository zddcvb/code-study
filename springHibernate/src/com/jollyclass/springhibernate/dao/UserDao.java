package com.jollyclass.springhibernate.dao;

import java.util.List;

import com.jollyclass.springhibernate.bean.User;

public interface UserDao {
	public User findUser(int id);

	public List<User> findAllUsers();

	public void insertUser(User user);

	public void updateUser(int id);

	public void deleteUser(int id);
}
