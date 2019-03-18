package com.jollyclass.file.servlert;

import java.io.File;
import java.io.FileInputStream;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.net.URLEncoder;

import javax.servlet.ServletException;
import javax.servlet.ServletOutputStream;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
/**
 * 下载文件
 * @author saber
 *
 */
@SuppressWarnings("serial")
public class DownLoadServlert extends HttpServlet {

	@Override
	protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
		System.out.println("doGet");
		String realPath = this.getServletContext().getRealPath("/WEB-INF/upload");
		String filename = "大班上2.png";
		File uploadFile=new File(realPath+File.separator+filename);
		System.out.println(uploadFile.getAbsolutePath());
		System.out.println(uploadFile.exists());
		if (uploadFile.exists()) {
			System.out.println("file exists");
			resp.setContentType("application/x-png");
			resp.setHeader("Content-Disposition", "attachment;filename=" +URLEncoder.encode(filename,"utf-8") );
			InputStream is=new FileInputStream(uploadFile);
			ServletOutputStream servletOutputStream=resp.getOutputStream();
			byte[] buffer=new byte[1024];
			int len=0;
			while((len=is.read(buffer))!=-1){
				servletOutputStream.write(buffer, 0, len);
			}
			servletOutputStream.close();
			is.close();
		}else{
			System.out.println("文件不存在");
		}
	}

	@Override
	protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
		
	}
	

}
