package com.yanxi.mp.service;

import com.yanxi.mp.bean.User;
import com.baomidou.mybatisplus.plugins.Page;
import com.baomidou.mybatisplus.service.IService;

/**
 * <p>
 *  服务类
 * </p>
 *
 * @author ${author}
 * @since 2018-07-24
 */
public interface UserService extends IService<User> {
	Page<User> selectUserPage(Page<User> page,Integer state);
}
