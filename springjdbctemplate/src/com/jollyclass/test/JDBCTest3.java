package com.jollyclass.test;

import java.beans.PropertyVetoException;
import java.util.List;

import javax.sql.DataSource;

import org.apache.commons.dbcp.BasicDataSource;
import org.junit.Test;
import org.springframework.context.ApplicationContext;
import org.springframework.context.support.ClassPathXmlApplicationContext;
import org.springframework.jdbc.core.BeanPropertyRowMapper;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.jdbc.datasource.DriverManagerDataSource;

import com.jollyclass.bean.User;
import com.mchange.v2.c3p0.ComboPooledDataSource;

public class JDBCTest3 {
	// 获得jdbcTemplate
	//第一种方式：setter注入,將jdbcTemplate当做一个类的属性来使用
	
/*	public JdbcTemplate getJdbcTemplate() {
		return jdbcTemplate;
	}

	public void setJdbcTemplate(JdbcTemplate jdbcTemplate) {
		this.jdbcTemplate = jdbcTemplate;
	}*/
	private JdbcTemplate jdbcTemplate;
	public void setDataSource(DataSource dataSource){
		jdbcTemplate=new JdbcTemplate(dataSource);
	}
	// 创建数据库
	@Test
	public void testCreate() {
		// 加载数据库信息
		//JdbcTemplate jdbcTemplate = getJdbcTemplate();
		// 执行sql语句
		String sql = "CREATE TABLE company(id INTEGER PRIMARY KEY AUTO_INCREMENT,NAME VARCHAR(50),age int)";
		jdbcTemplate.execute(sql);
	}

	// 插入数据库
	@Test
	public void testInsert() {
		//JdbcTemplate jdbcTemplate = getJdbcTemplate();
		for (int i = 0; i < 10; i++) {
			String sql = "insert into company(name,age) values(?,?)";
			jdbcTemplate.update(sql, new Object[] { "jack" + i, 20 + i });
		}
	}

	// 更新数据库
	@Test
	public void testUpdate() {
		//JdbcTemplate jdbcTemplate = getJdbcTemplate();
		// 第一种方式
		String sql1 = "UPDATE company SET NAME='lucy' WHERE id=16";
		jdbcTemplate.execute(sql1);
		// 第二种方式
		String sql = "update company set name=? where id=?";
		jdbcTemplate.update(sql, new Object[] { "lucy", 5 });

	}

	// 删除数据库数据
	@Test
	public void testDelete() {
		//JdbcTemplate jdbcTemplate = getJdbcTemplate();
		// 第一种方式
		String sql1 = "delete from company where id=16";
		jdbcTemplate.execute(sql1);
		// 第二种方式
		String sql = "delete from company where id=?";
		jdbcTemplate.update(sql, new Object[] { 8 });
	}

	// 查询所有数据文件
	@Test
	public void testQuery() {
		//JdbcTemplate jdbcTemplate = getJdbcTemplate();
		String sql = "select * from company";
		// 第一种方式:通过配置的方式进行，只能用这种方式，不建议用queryforlist
		List<User> query = jdbcTemplate.query(sql, new BeanPropertyRowMapper<User>(User.class));
		System.out.println(query);
	}

	// 根据id查询数据库信息
	@Test
	public void testQueryId() {
		//JdbcTemplate jdbcTemplate = getJdbcTemplate();
		String sql = "select id,name,age from company where id=? and name=?";
		User user = jdbcTemplate.queryForObject(sql, new Object[] { 10, "jack9" },
				new BeanPropertyRowMapper<User>(User.class));
		System.out.println(user);
	}

}
