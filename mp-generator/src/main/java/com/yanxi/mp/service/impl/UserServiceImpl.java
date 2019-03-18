package com.yanxi.mp.service.impl;

import com.yanxi.mp.bean.User;
import com.yanxi.mp.mapper.UserMapper;
import com.yanxi.mp.service.UserService;
import com.baomidou.mybatisplus.service.impl.ServiceImpl;
import org.springframework.stereotype.Service;

/**
 * <p>
 *  服务实现类
 * </p>
 *
 * @author ${author}
 * @since 2018-07-24
 */
@Service
public class UserServiceImpl extends ServiceImpl<UserMapper, User> implements UserService {

}
