<%@ page language="java" contentType="text/html; charset=utf-8"
    pageEncoding="utf-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<title>Insert title here</title>
</head>
<body>
	<form action="servlet/UploadFileServlert" enctype="multipart/form-data" method="post" >
		上传文件:<input type="file" name="upload"  ><br><br>
		上传文件:<input type="file" name="upload"  ><br><br>
		上传文件:<input type="file" name="upload"  ><br><br>
		<input type="submit" value="upload">
		<a href="servlet/DownLoadServlert">downLoad</a>
	</form>
</body>
</html>