package com.jollyclass.test;

import java.beans.PropertyVetoException;
import java.util.List;

import org.apache.commons.dbcp.BasicDataSource;
import org.junit.Test;
import org.springframework.jdbc.core.BeanPropertyRowMapper;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.jdbc.datasource.DriverManagerDataSource;

import com.jollyclass.bean.User;
import com.mchange.v2.c3p0.ComboPooledDataSource;

public class JDBCTest {
	// 获得jdbcTemplate
	public JdbcTemplate getJdbcTemplate() {
		DriverManagerDataSource dataSource = new DriverManagerDataSource();
		dataSource.setDriverClassName("com.mysql.jdbc.Driver");
		dataSource.setUrl("jdbc:mysql://localhost:3307/mydb");
		dataSource.setUsername("root");
		dataSource.setPassword("root");
		// 创建jdbc模板
		JdbcTemplate jdbcTemplate = new JdbcTemplate(dataSource);
		return jdbcTemplate;
	}

	// 创建数据库
	@Test
	public void testCreate() {
		// 加载数据库信息
		JdbcTemplate jdbcTemplate = getJdbcTemplate();
		// 执行sql语句
		String sql = "CREATE TABLE company(id INTEGER PRIMARY KEY AUTO_INCREMENT,NAME VARCHAR(50))";
		jdbcTemplate.execute(sql);
	}

	// 插入数据库
	@Test
	public void testInsert() {
		JdbcTemplate jdbcTemplate = getJdbcTemplate();
		for (int i = 0; i < 10; i++) {
			String sql1 = "INSERT INTO company(NAME,age) VALUES('jack',20)";
			jdbcTemplate.execute(sql1);
			String sql = "insert into company(name,age) values(?,?)";
			jdbcTemplate.update(sql, new Object[] { "jack" + i, 20 + i });
		}
	}

	// 更新数据库
	@Test
	public void testUpdate() {
		JdbcTemplate jdbcTemplate = getJdbcTemplate();
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
		JdbcTemplate jdbcTemplate = getJdbcTemplate();
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
		JdbcTemplate jdbcTemplate = getJdbcTemplate();
		String sql = "select * from company";
		// 第一种方式
		List<User> query = jdbcTemplate.query(sql, new BeanPropertyRowMapper<User>(User.class));
		// 第二种方式
		List<User> users = jdbcTemplate.queryForList(sql, User.class);
		System.out.println(users);
	}

	// 根据id查询数据库信息
	@Test
	public void testQueryId() {
		JdbcTemplate jdbcTemplate = getJdbcTemplate();
		String sql = "select id,name,age from company where id=? and name=?";
		User user = jdbcTemplate.queryForObject(sql, new Object[] { 10, "jack9" },
				new BeanPropertyRowMapper<User>(User.class));
		System.out.println(user);
	}
	//dbcp数据源
	@Test
	public void testDataSource(){
		BasicDataSource dataSource=new BasicDataSource();
		dataSource.setDriverClassName("com.mysql.jdbc.Driver");
		dataSource.setUrl("jdbc:mysql://localhost:3307/mydb");
		dataSource.setUsername("root");
		dataSource.setPassword("root");
	}
	//c3p0数据源
	@Test
	public void testDataSource2() throws PropertyVetoException{
		ComboPooledDataSource dataSource=new ComboPooledDataSource();
		dataSource.setDriverClass("com.mysql.jdbc.Driver");
		dataSource.setJdbcUrl("jdbc:mysql://localhost:3307/mydb");
		dataSource.setUser("root");
		dataSource.setPassword("root");
	}
}
