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
	// ���jdbcTemplate
	//��һ�ַ�ʽ��setterע��,��jdbcTemplate����һ�����������ʹ��
	
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
	// �������ݿ�
	@Test
	public void testCreate() {
		// �������ݿ���Ϣ
		//JdbcTemplate jdbcTemplate = getJdbcTemplate();
		// ִ��sql���
		String sql = "CREATE TABLE company(id INTEGER PRIMARY KEY AUTO_INCREMENT,NAME VARCHAR(50),age int)";
		jdbcTemplate.execute(sql);
	}

	// �������ݿ�
	@Test
	public void testInsert() {
		//JdbcTemplate jdbcTemplate = getJdbcTemplate();
		for (int i = 0; i < 10; i++) {
			String sql = "insert into company(name,age) values(?,?)";
			jdbcTemplate.update(sql, new Object[] { "jack" + i, 20 + i });
		}
	}

	// �������ݿ�
	@Test
	public void testUpdate() {
		//JdbcTemplate jdbcTemplate = getJdbcTemplate();
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
		//JdbcTemplate jdbcTemplate = getJdbcTemplate();
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
		//JdbcTemplate jdbcTemplate = getJdbcTemplate();
		String sql = "select * from company";
		// ��һ�ַ�ʽ:ͨ�����õķ�ʽ���У�ֻ�������ַ�ʽ����������queryforlist
		List<User> query = jdbcTemplate.query(sql, new BeanPropertyRowMapper<User>(User.class));
		System.out.println(query);
	}

	// ����id��ѯ���ݿ���Ϣ
	@Test
	public void testQueryId() {
		//JdbcTemplate jdbcTemplate = getJdbcTemplate();
		String sql = "select id,name,age from company where id=? and name=?";
		User user = jdbcTemplate.queryForObject(sql, new Object[] { 10, "jack9" },
				new BeanPropertyRowMapper<User>(User.class));
		System.out.println(user);
	}

}
