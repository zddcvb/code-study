package com.yanxi.mybatis.service.impl;

import java.io.IOException;
import java.io.InputStream;
import java.util.List;
import java.util.Map;
import org.apache.commons.logging.impl.Log4JLogger;
import org.apache.ibatis.datasource.pooled.PooledDataSource;
import org.apache.ibatis.io.Resources;
import org.apache.ibatis.session.SqlSession;
import org.apache.ibatis.session.SqlSessionFactory;
import org.apache.ibatis.session.SqlSessionFactoryBuilder;
import org.apache.log4j.Logger;

import com.yanxi.mybatis.pojo.Employee;
import com.yanxi.mybatis.service.EmployeeService;

public class EmployeeServiceImpl implements EmployeeService {
	private Logger logger = Logger.getLogger(EmployeeServiceImpl.class);

	private SqlSession getSession() {
		SqlSession session = null;
		try {
			System.out.println("------sqlsession start-------");
			InputStream is = Resources.getResourceAsStream("mybatis.xml");
			SqlSessionFactory factory = new SqlSessionFactoryBuilder().build(is);
			session = factory.openSession();
		} catch (IOException e) {
			e.printStackTrace();
		}
		System.out.println("-----sqlsession end----");
		return session;
	}

	@Override
	public List<Employee> selectAll() {
		SqlSession session = getSession();
		List<Employee> list = session.selectList("com.yanxi.mybatis.mapper.Employee.findAll");
		for (Employee employee : list) {
			System.out.println(employee);
			logger.info("employee:"+employee);
		}
		logger.info("selectAll:" + list);
		return list;
	}

	@Override
	public List<Employee> selectByIds(int[] ids) {
		SqlSession session = getSession();
		List<Employee> list = session.selectList("com.yanxi.mybatis.mapper.Employee.selectByIds", ids);
		logger.info("selectByIds:" + list);
		return list;
	}
	@Override
	public List<Employee> selectByList(List<Integer> ids) {
		SqlSession session = getSession();
		List<Employee> list = session.selectList("com.yanxi.mybatis.mapper.Employee.selectByList", ids);
		logger.info("selectByIds:" + list);
		return list;
	}

	@Override
	public Employee selectById(int id) {
		SqlSession session = getSession();
		Employee employee = session.selectOne("com.yanxi.mybatis.mapper.Employee.selectById", new Integer(id));
		logger.info("selectById:" + employee);
		return employee;
	}

	@Override
	public void insert(Employee employee) {
		SqlSession session = getSession();
		int insertFlag = session.insert("com.yanxi.mybatis.mapper.Employee.insert", employee);
		logger.info("insertFlag:" + insertFlag);
		PooledDataSource dataSource = new PooledDataSource();
		session.commit();
	}

	@Override
	public void update(Employee employee) {
		SqlSession session = getSession();
		int updateFlag = session.update("com.yanxi.mybatis.mapper.Employee.update", employee);
		logger.info("updateFlag:" + updateFlag);
		System.out.println(updateFlag);
		session.commit();
	}

	@Override
	public void delete(int id) {
		SqlSession session = getSession();
		int flag = session.delete("com.yanxi.mybatis.mapper.Employee.delete", id);
		System.out.println(flag);
		logger.info("delete:" + flag);
		session.commit();
	}

	@Override
	public List<Employee> selectByMap(Map<String, Object> ids) {
		SqlSession session = getSession();
		List<Employee> list = session.selectList("com.yanxi.mybatis.mapper.Employee.selectByMap", ids);
		logger.info("selectByIds:" + list);
		return list;
	}

}
