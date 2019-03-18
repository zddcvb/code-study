<%@ page language="java" contentType="text/html; charset=utf-8"
	pageEncoding="utf-8"%>
<%@taglib prefix="s" uri="/struts-tags"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<title>Insert title here</title>
</head>
<body>
	<s:form action="load_upload" enctype="multipart/form-data"
		namespace="/">
		上传文件:<input type="file" name="upload">
		<br>
		<br>
		<input type="submit" value="upload">
		<s:a action="load_download" namespace="/">downLoad</s:a>
	</s:form>
</body>
</html>