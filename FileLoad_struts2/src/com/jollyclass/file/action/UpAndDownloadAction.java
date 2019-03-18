package com.jollyclass.file.action;

import java.io.File;
import java.io.FileInputStream;
import java.io.FileNotFoundException;
import java.io.IOException;
import java.io.InputStream;

import org.apache.commons.io.FileUtils;
import org.apache.struts2.ServletActionContext;

import com.opensymphony.xwork2.ActionContext;
import com.opensymphony.xwork2.ActionSupport;

@SuppressWarnings("serial")
public class UpAndDownloadAction extends ActionSupport {
	private File upload;
	private InputStream inputStream;
	private File newFile;

	public String upload() {
		System.out.println("upload");
		getPath();
		return "upload";
	}

	private String getPath() {
		String realPath = ServletActionContext.getServletContext().getRealPath("/WEB-INF/uploadFile/");
		String absolutePath = upload.getAbsolutePath();
		String filename = absolutePath.substring(absolutePath.lastIndexOf("\\")+1);
		System.out.println(filename);
		File rootFile = new File(realPath);
		if (!rootFile.exists()) {
			rootFile.mkdirs();
		}
		 newFile = new File(realPath + File.separator + filename);
		System.out.println(newFile.getAbsolutePath());
		try {
			FileUtils.copyFile(upload, newFile);
		} catch (IOException e) {
			e.printStackTrace();
		}
		return newFile.getAbsolutePath();
	}

	public String download() {
		System.out.println("downLoad");
		String fileName = "¥Û∞‡…œ2.png";
		ActionContext.getContext().put("fileName", fileName);
		System.out.println(newFile.getAbsolutePath());
		try {
			inputStream = new FileInputStream(newFile);
		} catch (FileNotFoundException e) {
			e.printStackTrace();
		}
		return "download";
	}

	public File getUpload() {
		return upload;
	}

	public void setUpload(File upload) {
		this.upload = upload;
	}

	public InputStream getInputStream() {
		return inputStream;
	}

	public void setInputStream(InputStream inputStream) {
		this.inputStream = inputStream;
	}

}
