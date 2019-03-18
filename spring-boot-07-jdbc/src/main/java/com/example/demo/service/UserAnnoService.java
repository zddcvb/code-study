package com.example.demo.service;

import java.util.List;

import com.example.demo.bean.UserAnno;

public interface UserAnnoService {
	public List<UserAnno> findAll();

	public UserAnno findById(int id);

	public void insert(UserAnno userAnno);

	public void update(UserAnno userAnno);

	public void delete(int id);

	public void deteteAll();
}
