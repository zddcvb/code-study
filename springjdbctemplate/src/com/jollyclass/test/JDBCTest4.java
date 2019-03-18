package com.jollyclass.test;

import java.util.List;

import org.junit.Test;
import org.springframework.jdbc.core.BeanPropertyRowMapper;
import org.springframework.jdbc.core.support.JdbcDaoSupport;

import com.jollyclass.bean.User;

public class JDBCTest4 extends JdbcDaoSupport{
	// �������ݿ�
	@Test
	public void testCreate() {
		// �������ݿ���Ϣ
		//JdbcTemplate jdbcTemplate = getJdbcTemplate();
		// ִ��sql���
		String sql = "CREATE TABLE company(id INTEGER PRIMARY KEY AUTO_INCREMENT,NAME VARCHAR(50),age int)";
		this.getJdbcTemplate().execute(sql);
	}

	// �������ݿ�
	@Test
	public void testInsert() {
		//JdbcTemplate jdbcTemplate = getJdbcTemplate();
		for (int i = 0; i < 10; i++) {
			String sql = "insert into company(name,age) values(?,?)";
			this.getJdbcTemplate().update(sql, new Object[] { "jack" + i, 20 + i });
		}
	}

	// �������ݿ�
	@Test
	public void testUpdate() {
		//JdbcTemplate jdbcTemplate = getJdbcTemplate();
		// ��һ�ַ�ʽ
		String sql1 = "UPDATE company SET NAME='lucy' WHERE id=16";
		this.getJdbcTemplate().execute(sql1);
		// �ڶ��ַ�ʽ
		String sql = "update company set name=? where id=?";
		this.getJdbcTemplate().update(sql, new Object[] { "lucy", 5 });
	}

	// ɾ�����ݿ�����
	@Test
	public void testDelete() {
		//JdbcTemplate jdbcTemplate = getJdbcTemplate();
		// ��һ�ַ�ʽ
		String sql1 = "delete from company where id=16";
		this.getJdbcTemplate().execute(sql1);
		// �ڶ��ַ�ʽ
		String sql = "delete from company where id=?";
		this.getJdbcTemplate().update(sql, new Object[] { 8 });
	}

	// ��ѯ���������ļ�
	@Test
	public void testQuery() {
		//JdbcTemplate jdbcTemplate = getJdbcTemplate();
		String sql = "select * from company";
		// ��һ�ַ�ʽ:ͨ�����õķ�ʽ���У�ֻ�������ַ�ʽ����������queryforlist
		List<User> query = this.getJdbcTemplate().query(sql, new BeanPropertyRowMapper<User>(User.class));
		System.out.println(query);
	}

	// ����id��ѯ���ݿ���Ϣ
	@Test
	public void testQueryId() {
		//JdbcTemplate jdbcTemplate = getJdbcTemplate();
		String sql = "select id,name,age from company where id=? and name=?";
		User user = this.getJdbcTemplate().queryForObject(sql, new Object[] { 10, "jack9" },
				new BeanPropertyRowMapper<User>(User.class));
		System.out.println(user);
	}

}
