package com.jollyclass.spring.jdbc.dao.impl;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

import javax.sql.DataSource;

import com.jollyclass.spring.jdbc.bean.User;
import com.jollyclass.spring.jdbc.dao.UserDao;

public class UserDaoImpl implements UserDao {
	//set×¢Èë
	private DataSource dataSource;

	public DataSource getDataSource() {
		return dataSource;
	}

	public void setDataSource(DataSource dataSource) {
		this.dataSource = dataSource;
	}

	@Override
	public User findUser(int id) {
		User user = null;
		String sql = "select * from user where id=?";
		try {
			Connection connection = dataSource.getConnection();
			PreparedStatement ps = connection.prepareStatement(sql);
			ps.setInt(1, id);
			ResultSet set = ps.executeQuery();
			if (set.next()) {
				user = new User();
				int userId = set.getInt("id");
				String name = set.getString("name");
				int age = set.getInt("age");
				user.setId(userId);
				user.setName(name);
				user.setAge(age);
				return user;
			}
			ps.close();
			connection.close();
		} catch (SQLException e) {
			e.printStackTrace();
		}
		return null;
	}

	@Override
	public List<User> findAllUsers() {
		ArrayList<User> users = new ArrayList<User>();
		String sql = "select * from user";
		try {
			Connection conn = dataSource.getConnection();
			PreparedStatement ps = conn.prepareStatement(sql);
			ResultSet set = ps.executeQuery();
			User user = null;
			while (set.next()) {
				user = new User();
				int id = set.getInt("id");
				String name = set.getString("name");
				int age = set.getInt("age");
				user.setId(id);
				user.setName(name);
				user.setAge(age);
				users.add(user);
			}
			ps.close();
			conn.close();
			// System.out.println(users.toString());
			return users;
		} catch (SQLException e) {
			e.printStackTrace();
		}
		return null;
	}

	@Override
	public void insertUser(User user) {
		String sql = "insert into user (id,name,age) values(?,?,?)";
		try {
			Connection conn = dataSource.getConnection();
			PreparedStatement ps = conn.prepareStatement(sql);
			ps.setInt(1, user.getId());
			ps.setString(2, user.getName());
			ps.setInt(3, user.getAge());
			int index = ps.executeUpdate();
			if (index > 0) {
				System.out.println("insert into user successful");
			} else {
				System.out.println("insert into user error");
			}
			ps.close();
			conn.close();
		} catch (SQLException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
	}

	@Override
	public void updateUser(User user) {
		String sql = "UPDATE USER SET NAME=?,age=? WHERE id=?";
		try {
			Connection conn = dataSource.getConnection();
			PreparedStatement ps = conn.prepareStatement(sql);
			ps.setInt(3, user.getId());
			ps.setString(1, user.getName());
			ps.setInt(2, user.getAge());
			int index = ps.executeUpdate();
			if (index > 0) {
				System.out.println("update user successful");
			} else {
				System.out.println("update  user error");
			}
			ps.close();
			conn.close();
		} catch (SQLException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
	}

	@Override
	public void deleteUser(int id) {
		String sql = "delete  from user where id=?";
		try {
			Connection conn = dataSource.getConnection();
			PreparedStatement ps = conn.prepareStatement(sql);
			ps.setInt(1, id);
			int index = ps.executeUpdate();
			if (index>0) {
				System.out.println("delete user successful");
			} else {
				System.out.println("delete  user error");
			}
			ps.close();
			conn.close();
		} catch (SQLException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
	}

}
