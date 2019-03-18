package com.yanxi.h2.utils;

import java.io.FileNotFoundException;
import java.io.IOException;
import java.io.InputStream;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.Properties;

public class H2Utils {
	private String path;

	public H2Utils(String path) {
		this.path = path;
	}

	public Connection getConnection() {
		String className = "";
		String url = "";
		String username = "";
		String password = "";
		Connection connection = null;
		try {
			Properties properties = new Properties();
			InputStream is = getClass().getClassLoader().getResourceAsStream(path);
			properties.load(is);
			className = properties.getProperty("driver");
			url = properties.getProperty("url");
			username = properties.getProperty("username");
			password = properties.getProperty("password");
			Class.forName(className);
			connection = DriverManager.getConnection(url, username, password);
		} catch (ClassNotFoundException e) {
			e.printStackTrace();
		} catch (SQLException e) {
			e.printStackTrace();
		} catch (FileNotFoundException e) {
			e.printStackTrace();
		} catch (IOException e) {
			e.printStackTrace();
		}
		return connection;
	}

	public void findAll() {
		Connection connection = getConnection();
		try {
			PreparedStatement ps = connection.prepareStatement("select * from userinfo");
			ResultSet resultSet = ps.executeQuery();
			while (resultSet.next()) {
				int id = resultSet.getInt("id");
				String name = resultSet.getString("name");
				System.out.println(id + "::" + name);
			}
			connection.close();
		} catch (SQLException e) {
			e.printStackTrace();
		}
	}
}
