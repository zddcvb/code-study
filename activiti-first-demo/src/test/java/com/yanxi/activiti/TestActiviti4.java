package com.yanxi.activiti;

import java.io.InputStream;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.activiti.engine.HistoryService;
import org.activiti.engine.IdentityService;
import org.activiti.engine.ProcessEngine;
import org.activiti.engine.ProcessEngineConfiguration;
import org.activiti.engine.RepositoryService;
import org.activiti.engine.RuntimeService;
import org.activiti.engine.TaskService;
import org.activiti.engine.history.HistoricActivityInstance;
import org.activiti.engine.history.HistoricProcessInstance;
import org.activiti.engine.history.HistoricTaskInstance;
import org.activiti.engine.repository.Deployment;
import org.activiti.engine.repository.ProcessDefinition;
import org.activiti.engine.runtime.ProcessInstance;
import org.activiti.engine.task.Task;
import org.junit.Before;
import org.junit.Test;

public class TestActiviti4 {
	private ProcessEngine processEngine;
	private RepositoryService repositoryService;
	private RuntimeService runtimeService;
	private TaskService taskService;
	private IdentityService identityService;
	private HistoryService historyService;

	@Before
	public void test_engine() {
		InputStream inputStream = TestActiviti4.class.getClassLoader().getResourceAsStream("activiti.cfg.xml");
		ProcessEngineConfiguration processEngineConfiguration = ProcessEngineConfiguration
				.createProcessEngineConfigurationFromInputStream(inputStream);
		System.out.println("processEngineConfiguration:" + processEngineConfiguration);
		processEngine = processEngineConfiguration.buildProcessEngine();
		System.out.println(processEngine.getName());
		repositoryService = processEngine.getRepositoryService();
		runtimeService = processEngine.getRuntimeService();
		taskService = processEngine.getTaskService();
		identityService = processEngine.getIdentityService();
		historyService = processEngine.getHistoryService();
	}

	/**
	 * 部署流程
	 */
	@Test
	public void test_deploy() {
		repositoryService = processEngine.getRepositoryService();
		Deployment deploy = repositoryService.createDeployment().name("class1").category("yanxi.class1")
				.addClasspathResource("MyProcess1.bpmn").addClasspathResource("MyProcess1.png").deploy();
		ProcessDefinition singleResult = repositoryService.createProcessDefinitionQuery().deploymentId(deploy.getId())
				.singleResult();

		runtimeService = processEngine.getRuntimeService();
		identityService = processEngine.getIdentityService();
		identityService.setAuthenticatedUserId("hehe1");
		ProcessInstance processInstance = runtimeService.startProcessInstanceById(singleResult.getId());
		System.out.println(processInstance.getId());
	}

	/**
	 * 完成请假任务，提交经理审核
	 */
	@Test
	public void test_task1() {
		String assignee = "jack";
		Task task = taskService.createTaskQuery().taskAssignee(assignee).singleResult();
		taskService.complete(task.getId());
		System.out.println(assignee + "完成请假任务提交");
	}

	/**
	 * 经理开始审核，提交至副总审核
	 */
	@Test
	public void test_task2() {
		String assignee = "mary";
		Task task = taskService.createTaskQuery().taskAssignee(assignee).singleResult();
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("condition", 4);
		taskService.complete(task.getId(), map);
		System.out.println("经理完成审核");
	}

	/**
	 * 副总审核，直至通过
	 */
	@Test
	public void test_task3() {
		String assignee = "lucy";
		Task task = taskService.createTaskQuery().taskAssignee(assignee).singleResult();
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("condition", 1);
		taskService.complete(task.getId(), map);
		System.out.println("副总完成審核");
	}

	/**
	 * 删除所有已經完成任务
	 */
	@Test
	public void test_deleteAllTask() {
		List<Task> list = taskService.createTaskQuery().list();
		for (Task task : list) {
			taskService.deleteTask(task.getId());
		}
		System.out.println("delete sucess");
	}

	@Test
	public void test_deleteRunningTask() {
		List<ProcessInstance> list = runtimeService.createProcessInstanceQuery().list();
		for (ProcessInstance processInstance : list) {
			runtimeService.deleteProcessInstance(processInstance.getId(), null);
		}
	}

	@Test
	public void test_historyPro() {
		List<HistoricProcessInstance> list = historyService.createHistoricProcessInstanceQuery().list();
		for (HistoricProcessInstance historicProcessInstance : list) {
			historyService.deleteHistoricProcessInstance(historicProcessInstance.getId());
		}
	}

	@Test
	public void test_deleteDeploy() {
		List<Deployment> list = repositoryService.createDeploymentQuery().list();
		for (Deployment deployment : list) {
			repositoryService.deleteDeployment(deployment.getId());

		}
	}

	/**
	 * 查询历史的流程任务，获取各个对应的字段 act_his_actinst
	 */
	@Test
	public void test_actInst() {
		String activityInstanceId = "7805";
		String activityname = "End";
		HistoricActivityInstance historicActivityInstance = historyService.createHistoricActivityInstanceQuery()
				.activityName(activityname).activityInstanceId(activityInstanceId).singleResult();
		System.out.println(historicActivityInstance);
		System.out.println("act_id:"+historicActivityInstance.getActivityId());
		System.out.println("act_name:"+historicActivityInstance.getActivityName());
		System.out.println("act_type:"+historicActivityInstance.getActivityType());
		System.out.println("assignee:"+historicActivityInstance.getAssignee());
		System.out.println("id:"+historicActivityInstance.getId());
		System.out.println("proc_inst_id:"+historicActivityInstance.getProcessInstanceId());
		System.out.println("proc_def_id:"+historicActivityInstance.getProcessDefinitionId());
		System.out.println("task_id:"+historicActivityInstance.getTaskId());
		System.out.println("execution_id:"+historicActivityInstance.getExecutionId());
	}
	/**
	 * 获取act_his_taskinst表中数据
	 */
	@Test
	public void test_his_taskinst(){
		List<HistoricTaskInstance> list = historyService.createHistoricTaskInstanceQuery().list();
		for (HistoricTaskInstance historicTaskInstance : list) {
			System.out.println("assignee:"+historicTaskInstance.getAssignee());
			System.out.println("execution_id:"+historicTaskInstance.getExecutionId());
			System.out.println("id:"+historicTaskInstance.getId());
			System.out.println("name:"+historicTaskInstance.getName());
			System.out.println("proc_inst_id:"+historicTaskInstance.getProcessDefinitionId());
			System.out.println("proc_inst_id:"+historicTaskInstance.getProcessInstanceId());
			System.out.println("task_def_key:"+historicTaskInstance.getTaskDefinitionKey());
			System.out.println("-----------------------------------");
		}
	}
	/**
	 * 获取act_hist_proinst数据表的数据
	 */
	@Test
	public void test_his_procinst(){
		List<HistoricProcessInstance> list = historyService.createHistoricProcessInstanceQuery().list();
		for (HistoricProcessInstance historicProcessInstance : list) {
			System.out.println("id:"+historicProcessInstance.getId());
			System.out.println("proc_def_id:"+historicProcessInstance.getProcessDefinitionId());
			System.out.println("start_act_id:"+historicProcessInstance.getStartActivityId());
			System.out.println("end_act_id:"+historicProcessInstance.getEndActivityId());
			System.out.println("start_user_id:"+historicProcessInstance.getStartUserId());
			System.out.println("pro_inst_id:"+historicProcessInstance.getId());
		}
	}
}
