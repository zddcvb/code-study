package com.example.demo.mapper;

import java.util.List;

import org.apache.ibatis.annotations.Mapper;

import com.example.demo.bean.User;

@Mapper
public interface UserMapper {
	public List<User> findAll();

	public User findById(int id);

	public void insert(User user);

	public void update(User user);

	public void delete(int id);

	public void deteteAll();
}
