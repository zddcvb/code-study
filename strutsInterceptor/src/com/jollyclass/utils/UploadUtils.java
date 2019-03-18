package com.jollyclass.utils;

import java.io.File;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.UUID;
import java.util.logging.SimpleFormatter;

import org.apache.struts2.ServletActionContext;

public class UploadUtils {
	public static String  getUploadFile(File upload){
		SimpleDateFormat formater=new SimpleDateFormat("yyyy-MM-DD");
		String realPath = ServletActionContext.getServletContext().getRealPath("/WEB-INF/upload");
		String date=formater.format(new Date());
		File file=new File(realPath+"/"+date);
		if (!file.exists()) {
			file.mkdirs();
		}
		String path=realPath+date+UUID.randomUUID().toString();
		File newFile=new File(path);
		upload.renameTo(newFile);
		return path;	
	}
}
