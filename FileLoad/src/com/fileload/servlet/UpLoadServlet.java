package com.fileload.servlet;

import java.io.BufferedOutputStream;
import java.io.File;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.io.OutputStream;
import java.util.List;
import java.util.UUID;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.commons.fileupload.FileItem;
import org.apache.commons.fileupload.FileUploadException;
import org.apache.commons.fileupload.disk.DiskFileItemFactory;
import org.apache.commons.fileupload.servlet.ServletFileUpload;
import org.apache.commons.io.IOUtils;

/**
 * Servlet implementation class UpLoadServlet
 */
@WebServlet("/UpLoadServlet")
public class UpLoadServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;

	/**
	 * @see HttpServlet#HttpServlet()
	 */
	public UpLoadServlet() {
		super();
		// TODO Auto-generated constructor stub
	}

	/**
	 * @see HttpServlet#doGet(HttpServletRequest request, HttpServletResponse
	 *      response)
	 */
	protected void doGet(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		doPost(request, response);
	}

	/**
	 * @see HttpServlet#doPost(HttpServletRequest request, HttpServletResponse
	 *      response)
	 */
	protected void doPost(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		DiskFileItemFactory factory = new DiskFileItemFactory();
		ServletFileUpload upload = new ServletFileUpload(factory);
		try {
			List<FileItem> lists = upload.parseRequest(request);
			for (FileItem fileItem : lists) {
				String fieldName = fileItem.getFieldName();
				String value = fileItem.getString();
				if (fileItem.isFormField()) {
					System.out.println(value);
				} else {
					String name = fileItem.getName();
					System.out.println("fileitem name:" + name);
					name = UUID.randomUUID().toString() + "_" + name;
					System.out.println("uuid name:" + name);
					String realpath = getServletContext().getRealPath("/uploads");
					System.out.println(realpath);
					File file = new File(realpath, name);
					System.out.println("path:" + file.getAbsolutePath());
					InputStream input = fileItem.getInputStream();
					OutputStream output = new BufferedOutputStream(new FileOutputStream(file));
					// IOUtils.copy(input, output);
					byte[] buffer = new byte[1024];
					int len = 0;
					while ((len = input.read(buffer)) != -1) {
						output.write(buffer, 0, len);
					}
					input.close();
					output.close();
				}
			}
		} catch (FileUploadException e) {
			e.printStackTrace();
		}
	}
}
