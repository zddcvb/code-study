package com.yanxi.activiti;

import java.io.InputStream;
import java.util.List;
import java.util.Map;

import org.activiti.engine.HistoryService;
import org.activiti.engine.ProcessEngine;
import org.activiti.engine.ProcessEngineConfiguration;
import org.activiti.engine.RepositoryService;
import org.activiti.engine.RuntimeService;
import org.activiti.engine.TaskService;
import org.activiti.engine.history.HistoricProcessInstance;
import org.activiti.engine.history.HistoricTaskInstance;
import org.activiti.engine.repository.Deployment;
import org.activiti.engine.runtime.ProcessInstance;
import org.activiti.engine.task.Task;

public class ActivitiServiceImpl implements ActivitiService {

	public ProcessEngine createProcessEnignee(InputStream inputStream) {
		ProcessEngineConfiguration configuration = ProcessEngineConfiguration
				.createProcessEngineConfigurationFromInputStream(inputStream);
		ProcessEngine processEngine = configuration.buildProcessEngine();
		if (processEngine != null) {
			return processEngine;
		}
		return null;
	}

	public Deployment deployProcess(ProcessEngine processEngine, String name, String category, String bpmn,
			String bpmn_png) {
		Deployment deployment = processEngine.getRepositoryService().createDeployment().name(name).category(category)
				.addClasspathResource(bpmn).addClasspathResource(bpmn_png).deploy();
		if (deployment != null) {
			return deployment;
		}
		return null;
	}

	public ProcessInstance startProcessInstance(ProcessEngine processEngine, String processDefinitionKey) {
		ProcessInstance processInstance = processEngine.getRuntimeService()
				.startProcessInstanceByKey(processDefinitionKey);
		if (processInstance != null) {
			return processInstance;
		}
		return null;
	}

	public List<Task> queryAllTask(ProcessEngine processEngine) {
		List<Task> list = processEngine.getTaskService().createTaskQuery().list();
		if (list.size() > 0) {
			return list;
		}
		return null;
	}

	public void deleteAllDeployment(ProcessEngine processEngine) {
		RepositoryService repositoryService = processEngine.getRepositoryService();
		List<Deployment> list = repositoryService.createDeploymentQuery().list();
		for (Deployment deployment : list) {
			repositoryService.deleteDeployment(deployment.getId());
		}
	}

	public void deleteAllRunningTask(ProcessEngine processEngine) {
			RuntimeService runtimeService = processEngine.getRuntimeService();
			List<ProcessInstance> list = runtimeService.createProcessInstanceQuery().list();
			for (ProcessInstance processInstance : list) {
				runtimeService.deleteProcessInstance(processInstance.getId(), null);
			}
	}

	public void deleteAllHistoryData(ProcessEngine processEngine) {
		HistoryService historyService = processEngine.getHistoryService();
		List<HistoricProcessInstance> list = historyService.createHistoricProcessInstanceQuery().list();
		for (HistoricProcessInstance historicProcessInstance : list) {
			historyService.deleteHistoricProcessInstance(historicProcessInstance.getId());
		}
		
		List<HistoricTaskInstance> taskList = historyService.createHistoricTaskInstanceQuery().list();
		for (HistoricTaskInstance historicTaskInstance : taskList) {
			historyService.deleteHistoricTaskInstance(historicTaskInstance.getId());
		}
	}



}
