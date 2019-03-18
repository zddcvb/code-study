package com.jollyclass.service.impl;

import com.jollycalss.dao.AccountDao;
import com.jollyclass.service.AccountService;

public class AccountServiceImpl implements AccountService {
	private AccountDao accountDao;

	public void setAccountDao(AccountDao accountDao) {
		this.accountDao = accountDao;
	}

	@Override
	public void tranfer(String outAccount, String inAccount, long money) {
		accountDao.out(outAccount, money);
		accountDao.in(inAccount, money);
	}

}
