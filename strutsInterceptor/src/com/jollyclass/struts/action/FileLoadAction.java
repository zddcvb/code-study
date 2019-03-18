package com.jollyclass.struts.action;

import java.io.File;

import com.jollyclass.utils.UploadUtils;
import com.opensymphony.xwork2.ActionSupport;

public class FileLoadAction extends ActionSupport{
	public File resource;
	
	public File getResource() {
		return resource;
	}

	public void setResource(File resource) {
		this.resource = resource;
	}

	public String fileload(){
		String uploadFile = UploadUtils.getUploadFile(resource);
		return null;
	}
}
