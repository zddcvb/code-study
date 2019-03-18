package com.jollycalss.dao;

public interface AccountDao {
	public void out(String account,long money);
	public void in(String account,long money);
}
