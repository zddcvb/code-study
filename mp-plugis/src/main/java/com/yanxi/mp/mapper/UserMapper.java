package com.yanxi.mp.mapper;

import java.util.List;

import com.baomidou.mybatisplus.mapper.BaseMapper;
import com.baomidou.mybatisplus.plugins.pagination.Pagination;
import com.yanxi.mp.bean.User;

/**
 * <p>
 * Mapper 接口
 * </p>
 *
 * @author ${author}
 * @since 2018-07-24
 */
public interface UserMapper extends BaseMapper<User> {
	List<User> selectUserList(Pagination page, Integer state);
}
