package com.yanxi.activiti;

import java.io.InputStream;
import java.util.List;
import java.util.zip.ZipInputStream;

import org.activiti.engine.FormService;
import org.activiti.engine.HistoryService;
import org.activiti.engine.IdentityService;
import org.activiti.engine.ManagementService;
import org.activiti.engine.ProcessEngine;
import org.activiti.engine.ProcessEngineConfiguration;
import org.activiti.engine.RepositoryService;
import org.activiti.engine.RuntimeService;
import org.activiti.engine.TaskService;
import org.activiti.engine.repository.Deployment;
import org.activiti.engine.repository.DeploymentQuery;
import org.activiti.engine.repository.ProcessDefinition;
import org.activiti.engine.repository.ProcessDefinitionQuery;
import org.activiti.engine.runtime.ProcessInstance;
import org.junit.Before;
import org.junit.Test;

public class ActivitiStartTest {
	private ProcessEngine processEngine;

	/**
	 * 通过配置文件创建流程引擎
	 */
	@Before
	public void test_processEngine() {
		System.out.println(this.getClass().getName());
		InputStream is = ActivitiStartTest.class.getClassLoader().getResourceAsStream("activiti.cfg.xml");
		ProcessEngineConfiguration configuration = ProcessEngineConfiguration
				.createProcessEngineConfigurationFromInputStream(is);
		System.out.println(configuration);
		processEngine = configuration.buildProcessEngine();
		System.out.println(processEngine.getName());
	}

	/**
	 * 通过代码创建引擎，但是官方建议尽量不使用
	 */
	@Test
	public void test_codeStart() {
		ProcessEngineConfiguration processEngineConfiguration = ProcessEngineConfiguration
				.createStandaloneProcessEngineConfiguration();
		processEngine = processEngineConfiguration.setJdbcDriver("com.mysql.jdbc.Driver").setJdbcUsername("root")
				.setJdbcPassword("root").setJdbcUrl("jdbc:mysql://localhost:3306/activiti").buildProcessEngine();
		System.out.println(processEngine);
	}

	/**
	 * processEngine引擎：用于创建各种service formService:表单服务 HistoryService：历史数据服务
	 * IdentityService：组织结构管理 ManagementService：日常系统管理服务
	 * RepositoryService：流程定义部署管理的服务 RuntimeService：运行时服务，管理流程的增删改查
	 * TaskService：任务服务
	 */
	@Test
	public void test_engine() {
		FormService formService = processEngine.getFormService();
		System.out.println(formService);
		HistoryService historyService = processEngine.getHistoryService();
		System.out.println(historyService);
		IdentityService identityService = processEngine.getIdentityService();
		System.out.println(identityService);
		ManagementService managementService = processEngine.getManagementService();
		System.out.println(managementService);
		RepositoryService repositoryService = processEngine.getRepositoryService();
		System.out.println(repositoryService);
		RuntimeService runtimeService = processEngine.getRuntimeService();
		System.out.println(runtimeService);
		TaskService taskService = processEngine.getTaskService();
		System.out.println(taskService);
		String name = processEngine.getName();
		System.out.println(name);
	}

	/**
	 * 部署流程 name：流程名稱 category：流程分类 addClassClasspathResource(""):通过流程图的名称
	 * 
	 */
	@Test
	public void test_reposityService() {
		RepositoryService repositoryService = processEngine.getRepositoryService();
		Deployment deploy = repositoryService.createDeployment().name("activiti").category("demo")
				.addClasspathResource("anim.bpmn").deploy();
		System.out.println(deploy.getId());
		ProcessDefinitionQuery processDefinitionQuery = repositoryService.createProcessDefinitionQuery()
				.deploymentId(deploy.getId());
		System.out.println(processDefinitionQuery.list().size());
	}

	/**
	 * 通过inputStream流式方式部署流程图
	 */
	@Test
	public void test_inputStreamDeploy() {
		RepositoryService repositoryService = processEngine.getRepositoryService();
		InputStream inputStream = ActivitiStartTest.class.getClassLoader().getResourceAsStream("anim.bpmn");
		Deployment deploy2 = repositoryService.createDeployment().addInputStream("anim.bpmn", inputStream).deploy();
		System.out.println(deploy2.getId());
	}

	/**
	 * 通过zip的方式部署流程图
	 */
	@Test
	public void test_zipDeploy() {
		RepositoryService repositoryService = processEngine.getRepositoryService();
		InputStream inputStream = ActivitiStartTest.class.getClassLoader().getResourceAsStream("anim.bpmn.zip");
		ZipInputStream zipInputStream = new ZipInputStream(inputStream);
		Deployment deploy = repositoryService.createDeployment().addZipInputStream(zipInputStream).deploy();
		System.out.println(deploy.getId());
	}

	/**
	 * 查询所部署的文件 deploymentName：通过name查询，精确匹配 deploymentNameLike:name模糊查询
	 * 
	 * 
	 */
	@Test
	public void test_queryProcess() {
		DeploymentQuery query = processEngine.getRepositoryService().createDeploymentQuery().deploymentNameLike("act%");
		System.out.println(query.list());
	}

	/**
	 * repositoryService删除部署，会直接删除act_re_prodef中的流程定义
	 * repositoryService可直接操作这个两个表格：act_re_prodef ，act_re_deployment
	 */
	@Test
	public void test_repos() {
		RepositoryService repositoryService = processEngine.getRepositoryService();
		repositoryService.deleteDeployment("1501");
	}

	/**
	 * 1、ProcessDefinition:通过repositoryService获得，可以查询act_re_prodef里面的数据
	 * 2、runtimeService通过ProcessDefinition，来启动ProcessInstance，启动成功后，
	 * 将数据写入act_hi_proinst和act_ru_task中
	 *  3、 通过processInstance来获得相关的数据
	 */
	@Test
	public void test_createProcessInstance() {
		ProcessDefinitionQuery processDefinitionQuery = processEngine.getRepositoryService()
				.createProcessDefinitionQuery().deploymentId("1301");
		ProcessDefinition singleResult = processDefinitionQuery.singleResult();
		RuntimeService runtimeService = processEngine.getRuntimeService();
		ProcessInstance processInstance = runtimeService.startProcessInstanceById(singleResult.getId());
		System.out.println(processInstance.getId());
		System.out.println(processInstance.getProcessInstanceId());
		System.out.println(processInstance.getActivityId());
	}

	/**
	 * 刪除流程实例
	 */
	@Test
	public void test_deleteInstance() {
		RuntimeService runtimeService = processEngine.getRuntimeService();
		runtimeService.deleteProcessInstance("1801", null);
	}
	/**
	 * ProcessDefinition获得方式：
	 * 1、查询条件：
	 * deploymentId
	 * asc、desc
	 * orderby
	 * 2、获得单个还是多个：singleResult、list、listpage
	 */
	@Test
	public void test_queryPD() {
		// 通過id查询,获得单个s
		RepositoryService repositoryService = processEngine.getRepositoryService();
		ProcessDefinitionQuery processDefinitionQuery = repositoryService.createProcessDefinitionQuery()
				.deploymentId("1301");
		ProcessDefinition singleResult = processDefinitionQuery.singleResult();
		//查询所有
		List<ProcessDefinition> list = repositoryService.createProcessDefinitionQuery().list();
		for (ProcessDefinition processDefinition : list) {
			System.out.println(processDefinition.getDeploymentId());
			System.out.println(processDefinition.getKey());
			System.out.println(processDefinition.getName());
			System.out.println(processDefinition.getId());
			System.out.println(processDefinition.getDiagramResourceName());
			System.out.println(processDefinition.getResourceName());
			System.out.println(processDefinition.getVersion());
		}
	}

	/**
	 * 删除所有的流程定义，前提条件是当前的流程定义为启动流程实例，否则无法删除
	 */
	@Test
	public void test_delete() {
		RepositoryService repositoryService = processEngine.getRepositoryService();
		List<Deployment> list = repositoryService.createDeploymentQuery().list();

		for (Deployment deployment : list) {
			System.out.println(deployment.getId());
			repositoryService.deleteDeployment(deployment.getId());
		}
	}
}
