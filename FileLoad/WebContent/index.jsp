<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="utf-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<title>Insert title here</title>
</head>
<body>
	<form action="${pageContext.request.contextPath }/upload" method="post"  enctype="multipart/form-data" >
		文件上传：<input type="file" name="upload" vaule="文件上传" /> <input
			type="submit" name="submit" value="submit" />
	</form>
</body>
</html>