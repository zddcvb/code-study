package com.jollyclass.file.servlert;

import java.io.File;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.io.OutputStream;
import java.util.List;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.commons.fileupload.FileItem;
import org.apache.commons.fileupload.FileUploadException;
import org.apache.commons.fileupload.disk.DiskFileItemFactory;
import org.apache.commons.fileupload.servlet.ServletFileUpload;
/**
 * 上传文件的servlet，用的common-fileupload.jar和io包；
 * 可以实现多文件上传
 * 注意的是，form表单中一定是post提交方式
 * @author saber
 *
 */
@SuppressWarnings("serial")
public class UploadFileServlert extends HttpServlet {

	@Override
	protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
		System.out.println("doget");
	}

	@Override
	protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
		req.setCharacterEncoding("utf-8");
		//创建需要保存的文件路径，如果不存在，则新建
		String path=req.getServletContext().getRealPath("/WEB-INF/upload");
		File uploadFile=new File(path);
		if (!uploadFile.exists()) {
			uploadFile.mkdirs();
		}
		//通过diskFileItmeFactory来上传文件，设置保存文件路径为临时文件目录，同时设置大小
		DiskFileItemFactory factory=new DiskFileItemFactory();
		factory.setRepository(uploadFile);
		factory.setSizeThreshold(1024*1024);
		//通过servletFileUpload的api来上传文件，高效。
		ServletFileUpload fileUpload=new ServletFileUpload(factory);
		try {
			//解析request请求，判断获取的字段是表单还是file控件
			List<FileItem> fileItems = fileUpload.parseRequest(req);
			for (FileItem fileItem : fileItems) {
				String name = fileItem.getFieldName();
				//如果获取的是表单中的文本信息，则获取文件内容
				if (fileItem.isFormField()) {
					String content = fileItem.getString();
					req.setAttribute(name, content);
				}else{
					//得到file控件，则提取文件路径；
					//截取文件路径，获得文件名称，与保存路径组成新的file对象
					//开始写入
					String value = fileItem.getName();
					if (value==""||value==null) {
						continue;
					}
					int lastIndexOf = value.lastIndexOf("\\");
					String fileName = value.substring(lastIndexOf+1);
					File file=new File(path+File.separator+fileName);
					OutputStream os=new FileOutputStream(file);
					InputStream is = fileItem.getInputStream();
					byte[] buffer=new byte[1024];
					int len=0;
					while((len=is.read(buffer))!=-1){
						os.write(buffer, 0, len);
					}
					os.close();
					is.close();
				}
			}
		} catch (FileUploadException e) {
			e.printStackTrace();
		}
	}

}
