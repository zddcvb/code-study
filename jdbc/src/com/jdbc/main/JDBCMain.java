package com.jdbc.main;

import java.awt.List;
import java.security.Permissions;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;

import org.apache.commons.dbutils.QueryRunner;
import org.apache.commons.dbutils.handlers.BeanHandler;
import org.apache.commons.dbutils.handlers.BeanListHandler;

public class JDBCMain {
	public static void main(String[] args) {
		// select();
		query(2);
	}

	private static void query(int id) {
		QueryRunner runner = new QueryRunner(DBUtils.getDataSource());
		String sql = "select * from person ";
		try {
			ArrayList<Person> persons = (ArrayList<Person>) runner.query(sql,
					new BeanListHandler<Person>(Person.class));
			for (Person person : persons) {
				System.out.println(person.toString());
			}

		} catch (SQLException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}

	}

	private static void select() {
		// ×¢²áÇý¶¯
		try {
			Class.forName("com.mysql.jdbc.Driver");
			Connection connection = DriverManager.getConnection("jdbc:mysql://localhost:3307/mydb", "root", "root");
			Statement statement = connection.createStatement();
			ResultSet set = statement.executeQuery("select * from person");
			while (set.next()) {
				int id = set.getInt("person_id");
				String name = set.getString("name");
				int age = set.getInt("age");
				Object object = set.getObject("birthday");
				System.out.println(id + ":" + name + ":" + age + ":" + object.toString());
			}
		} catch (ClassNotFoundException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		} catch (SQLException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}

	}

}
