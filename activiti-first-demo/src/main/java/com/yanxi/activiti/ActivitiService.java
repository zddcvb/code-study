package com.yanxi.activiti;

import java.io.InputStream;
import java.util.List;

import org.activiti.engine.ProcessEngine;
import org.activiti.engine.repository.Deployment;
import org.activiti.engine.runtime.ProcessInstance;
import org.activiti.engine.task.Task;

public interface ActivitiService {

	public ProcessEngine createProcessEnignee(InputStream inputStream);

	public Deployment deployProcess(ProcessEngine processEngine, String name, String category, String bpmn,
			String bpmn_png);

	public ProcessInstance startProcessInstance(ProcessEngine processEngine, String processInstanceKey);

	public List<Task> queryAllTask(ProcessEngine processEngine);

	
	/**
	 * 刪除所有的部署的流程，但前提條件是部署的流程没有在运行，否则报错，删除成功后，会自动删除流程定义的数据
	 * @param processEngine
	 */
	public void deleteAllDeployment(ProcessEngine processEngine);
	/**
	 * 删除所有运行的task
	 * @param processEngine
	 */
	public void deleteAllRunningTask(ProcessEngine processEngine);	
	/**
	 * 删除所有的历史数据，删除历史的流程定义数据，会自动删除流程活动的实例数据
	 * @param processEngine
	 */
	public void deleteAllHistoryData(ProcessEngine processEngine);
	
}
