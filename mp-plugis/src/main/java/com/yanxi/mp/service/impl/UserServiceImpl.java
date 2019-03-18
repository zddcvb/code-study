package com.yanxi.mp.service.impl;

import com.yanxi.mp.bean.User;
import com.yanxi.mp.mapper.UserMapper;
import com.yanxi.mp.service.UserService;
import com.baomidou.mybatisplus.plugins.Page;
import com.baomidou.mybatisplus.service.impl.ServiceImpl;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

/**
 * <p>
 * 服务实现类
 * </p>
 *
 * @author ${author}
 * @since 2018-07-24
 */
@Service
public class UserServiceImpl extends ServiceImpl<UserMapper, User> implements UserService {
	@Autowired
	private UserMapper userMapper;

	public Page<User> selectUserPage(Page<User> page, Integer state) {
		List<User> list = userMapper.selectUserList(page, state);
		Page<User> pages = page.setRecords(list);
		return pages;
	}

}
