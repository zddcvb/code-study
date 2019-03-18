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
	// ���jdbcTemplate
	public JdbcTemplate getJdbcTemplate() {
		DriverManagerDataSource dataSource = new DriverManagerDataSource();
		dataSource.setDriverClassName("com.mysql.jdbc.Driver");
		dataSource.setUrl("jdbc:mysql://localhost:3307/mydb");
		dataSource.setUsername("root");
		dataSource.setPassword("root");
		// ����jdbcģ��
		JdbcTemplate jdbcTemplate = new JdbcTemplate(dataSource);
		return jdbcTemplate;
	}

	// �������ݿ�
	@Test
	public void testCreate() {
		// �������ݿ���Ϣ
		JdbcTemplate jdbcTemplate = getJdbcTemplate();
		// ִ��sql���
		String sql = "CREATE TABLE company(id INTEGER PRIMARY KEY AUTO_INCREMENT,NAME VARCHAR(50))";
		jdbcTemplate.execute(sql);
	}

	// �������ݿ�
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

	// �������ݿ�
	@Test
	public void testUpdate() {
		JdbcTemplate jdbcTemplate = getJdbcTemplate();
		// ��һ�ַ�ʽ
		String sql1 = "UPDATE company SET NAME='lucy' WHERE id=16";
		jdbcTemplate.execute(sql1);
		// �ڶ��ַ�ʽ
		String sql = "update company set name=? where id=?";
		jdbcTemplate.update(sql, new Object[] { "lucy", 5 });

	}

	// ɾ�����ݿ�����
	@Test
	public void testDelete() {
		JdbcTemplate jdbcTemplate = getJdbcTemplate();
		// ��һ�ַ�ʽ
		String sql1 = "delete from company where id=16";
		jdbcTemplate.execute(sql1);
		// �ڶ��ַ�ʽ
		String sql = "delete from company where id=?";
		jdbcTemplate.update(sql, new Object[] { 8 });
	}

	// ��ѯ���������ļ�
	@Test
	public void testQuery() {
		JdbcTemplate jdbcTemplate = getJdbcTemplate();
		String sql = "select * from company";
		// ��һ�ַ�ʽ
		List<User> query = jdbcTemplate.query(sql, new BeanPropertyRowMapper<User>(User.class));
		// �ڶ��ַ�ʽ
		List<User> users = jdbcTemplate.queryForList(sql, User.class);
		System.out.println(users);
	}

	// ����id��ѯ���ݿ���Ϣ
	@Test
	public void testQueryId() {
		JdbcTemplate jdbcTemplate = getJdbcTemplate();
		String sql = "select id,name,age from company where id=? and name=?";
		User user = jdbcTemplate.queryForObject(sql, new Object[] { 10, "jack9" },
				new BeanPropertyRowMapper<User>(User.class));
		System.out.println(user);
	}
	//dbcp����Դ
	@Test
	public void testDataSource(){
		BasicDataSource dataSource=new BasicDataSource();
		dataSource.setDriverClassName("com.mysql.jdbc.Driver");
		dataSource.setUrl("jdbc:mysql://localhost:3307/mydb");
		dataSource.setUsername("root");
		dataSource.setPassword("root");
	}
	//c3p0����Դ
	@Test
	public void testDataSource2() throws PropertyVetoException{
		ComboPooledDataSource dataSource=new ComboPooledDataSource();
		dataSource.setDriverClass("com.mysql.jdbc.Driver");
		dataSource.setJdbcUrl("jdbc:mysql://localhost:3307/mydb");
		dataSource.setUser("root");
		dataSource.setPassword("root");
	}
}
