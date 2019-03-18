package com.example.demo.mapper;

import java.util.List;

import org.apache.ibatis.annotations.Delete;
import org.apache.ibatis.annotations.Insert;
import org.apache.ibatis.annotations.Param;
import org.apache.ibatis.annotations.Select;
import org.apache.ibatis.annotations.Update;

import com.example.demo.bean.UserAnno;

public interface UserMapperAnno {
	@Select("select * from useranno")
	public List<UserAnno> findAll();

	@Select("select * from useranno where id=#{id}")
	public UserAnno findById(@Param("id") int id);

	@Insert("insert into useranno values(#{id},#{name},#{age})")
	public void insert(UserAnno userAnnoAnno);

	@Update("update useranno set name=#{name},age=#{age} where id=#{id}")
	public void update(UserAnno userAnno);

	@Delete("delete from useranno where id=#{id}")
	public void delete(@Param("id") int id);

	@Delete("delete from useranno ")
	public void deteteAll();
}
