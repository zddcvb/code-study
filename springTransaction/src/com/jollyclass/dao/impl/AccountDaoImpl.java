package com.jollyclass.dao.impl;

import org.springframework.jdbc.core.support.JdbcDaoSupport;

import com.jollycalss.dao.AccountDao;

public class AccountDaoImpl extends JdbcDaoSupport implements AccountDao {

	@Override
	public void out(String account, long money) {
		String sql = "update account set money=money-? where name=?";
		this.getJdbcTemplate().update(sql, new Object[] { money, account });
	}

	@Override
	public void in(String account, long money) {
		String sql = "update account set money=money+? where name=?";
		this.getJdbcTemplate().update(sql, new Object[] { money, account });
	}

}
