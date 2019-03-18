package com.yanxi.activiti;

import java.io.InputStream;
import java.util.HashMap;
import java.util.Map;

import org.activiti.engine.IdentityService;
import org.activiti.engine.ProcessEngine;
import org.activiti.engine.ProcessEngineConfiguration;
import org.activiti.engine.RepositoryService;
import org.activiti.engine.RuntimeService;
import org.activiti.engine.repository.Deployment;
import org.activiti.engine.repository.ProcessDefinition;
import org.activiti.engine.runtime.ProcessInstance;
import org.junit.Before;
import org.junit.Test;

public class TestActiviti {
	private ProcessEngine processEngine;
	@Before
	public void test_engine(){
		InputStream inputStream=TestActiviti.class.getClassLoader().getResourceAsStream("activiti.cfg.xml");
		ProcessEngineConfiguration processEngineConfiguration = ProcessEngineConfiguration.createProcessEngineConfigurationFromInputStream(inputStream);
		System.out.println("processEngineConfiguration:"+processEngineConfiguration);
		 processEngine = processEngineConfiguration.buildProcessEngine();
		 System.out.println(processEngine.getName());
	}
	
	@Test
	public void test_deploy(){
		RepositoryService repositoryService = processEngine.getRepositoryService();
		Deployment deploy = repositoryService.createDeployment().name("demo").category("yanxi").addClasspathResource("MyProcess1.bpmn").deploy();
		ProcessDefinition singleResult = repositoryService.createProcessDefinitionQuery().deploymentId(deploy.getId()).singleResult();
		
		RuntimeService runtimeService = processEngine.getRuntimeService();
		IdentityService identityService = processEngine.getIdentityService();
		identityService.setAuthenticatedUserId("123");
		ProcessInstance processInstance = runtimeService.startProcessInstanceById(singleResult.getId());
		System.out.println(processInstance.getId());
	}
	
	@Test
	public void test_next_none_map(){
		RuntimeService runtimeService = processEngine.getRuntimeService();
		runtimeService.signal("2005");
	}
	
	@Test
	public void test_next_map(){
		Map<String, Object> map=new HashMap<String, Object>();
		map.put("condition", 5);
		RuntimeService runtimeService = processEngine.getRuntimeService();
		runtimeService.signal("2005", map);
	}
}
